from typing import Any, Dict, List, Optional
from datetime import datetime, timedelta
from pydantic import BaseModel, field_validator
from fastapi import FastAPI
import dateutil.parser
import calendar
import logging
import pulp

app = FastAPI()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class TaskInput(BaseModel):
    taskId: str
    taskName: str
    estimatedDuration: float  # Input in minutes, will be converted to hours
    weight: float
    deadline: Optional[datetime] = None  # Bisa None
    taskType: Optional[str] = None

    @field_validator('deadline', mode='before')
    @classmethod
    def parse_deadline(cls, value):
        if value is None:
            return None
        if isinstance(value, datetime):
            return value
        try:
            return dateutil.parser.parse(value)
        except Exception as e:
            raise ValueError(f"Invalid datetime format: {value}") from e

class ScheduleRequest(BaseModel):
    daysToSchedule: int
    # weeklyWorkingHours: Optional[Dict[str, float]] = None  # Input in minutes per day name (optional)
    weeklyWorkingIntervals: Optional[Dict[str, List[Dict[str, str]]]] = None  # Input: {"Monday": [{"start": "08:00", "end": "12:00"}, ...]}
    excludedDates: List[datetime] = []
    tasks: List[TaskInput]
    workloadThreshold: float  # Input in minutes


class OptimizedTask(BaseModel):
    taskId: str
    taskName: str
    workload: Dict[str, List[Dict[str, Any]]]  # Output per day, per interval

class ScheduleResponse(BaseModel):
    tasks: List[OptimizedTask]

def generate_available_time(start_date: datetime, days: int, weekly_hours: Dict[str, float], excluded: List[str]) -> Dict[str, float]:
    excluded_set = set(excluded)
    result = {}
    for i in range(days):
        current = start_date + timedelta(days=i)
        weekday_name = calendar.day_name[current.weekday()]
        iso_date = current.strftime("%Y-%m-%d")
        result[iso_date] = 0 if iso_date in excluded_set else weekly_hours.get(weekday_name, 0)
    return result

def generate_available_time_interval(start_date: datetime, days: int, weekly_intervals: dict, excluded: List[str]) -> Dict[str, List[tuple]]:
    excluded_set = set(excluded)
    result = {}
    for i in range(days):
        current = start_date + timedelta(days=i)
        weekday_name = calendar.day_name[current.weekday()]
        iso_date = current.strftime("%Y-%m-%d")
        if iso_date in excluded_set:
            result[iso_date] = []
        else:
            # List of (start, end) tuples for the day
            intervals = weekly_intervals.get(weekday_name, [])
            result[iso_date] = [(interval['start'], interval['end']) for interval in intervals]
    return result

@app.post("/optimizeSchedule", response_model=ScheduleResponse)
def optimize_schedule(schedule: ScheduleRequest):
    print("[LP OPTIMIZER]Received schedule request:", schedule)
    today = datetime.now().date()
    logger.info("Received schedule request with %d tasks", len(schedule.tasks))

    # Convert estimatedDuration dari menit ke jam
    for task in schedule.tasks:
        task.estimatedDuration /= 60.0  # menit → jam

    # --- INTERVAL SUPPORT ---
    if hasattr(schedule, 'weeklyWorkingIntervals') and schedule.weeklyWorkingIntervals:
        availableIntervals = generate_available_time_interval(
            today, schedule.daysToSchedule, schedule.weeklyWorkingIntervals, [d.strftime('%Y-%m-%d') for d in schedule.excludedDates]
        )
        # Flatten intervals to availableTime per day (in hours)
        availableTime = {}
        for day, intervals in availableIntervals.items():
            total = 0
            for start, end in intervals:
                try:
                    sh, sm = map(int, start.split(':'))
                    eh, em = map(int, end.split(':'))
                except Exception:
                    sh, sm = _parse_time_to_24h(start)
                    eh, em = _parse_time_to_24h(end)
                start_minutes = sh * 60 + sm
                end_minutes = eh * 60 + em
                total += max(0, end_minutes - start_minutes)
            availableTime[day] = total / 60.0  # jam

        # --- INTERVAL-BASED LP VARIABLES ---
        tasks = schedule.tasks
        days = list(availableTime.keys())
        prob = pulp.LpProblem("TaskoraSchedule", pulp.LpMaximize)
        A = {day: pulp.LpVariable(f"A_{day}", lowBound=0, cat='Continuous') for day in days}
        Yd = {day: pulp.LpVariable(f"Y_{day}", cat='Binary') for day in days}
        cumulative_workload = {day: pulp.LpVariable(f"C_{day}", lowBound=0, cat='Continuous') for day in days}
        lambda_penalty = 200
        M = 1000

        # Build interval slots: x[taskId][day][intervalIdx]
        x = {}
        interval_lengths = {}  # interval_lengths[day][intervalIdx] = duration in hours
        for task in tasks:
            x[task.taskId] = {}
            for day in days:
                intervals = availableIntervals[day]
                x[task.taskId][day] = {}
                if intervals:  # hanya proses hari yang punya interval
                    for idx, (start, end) in enumerate(intervals):
                        try:
                            sh, sm = map(int, start.split(':'))
                            eh, em = map(int, end.split(':'))
                        except Exception:
                            sh, sm = _parse_time_to_24h(start)
                            eh, em = _parse_time_to_24h(end)
                        start_minutes = sh * 60 + sm
                        end_minutes = eh * 60 + em
                        length = max(0, end_minutes - start_minutes) / 60.0  # in hours
                        if day not in interval_lengths:
                            interval_lengths[day] = {}
                        interval_lengths[day][idx] = length
                        x[task.taskId][day][idx] = pulp.LpVariable(f"x_{task.taskId}_{day}_int{idx}", lowBound=0, cat='Continuous')

        # Only use days with interval for all LP logic
        interval_days = list(interval_lengths.keys())

        # Constraint: total assigned in all intervals for a task = estimatedDuration (in hours)
        for task in tasks:
            prob += pulp.lpSum(
                x[task.taskId][day][idx]
                for day in interval_days
                for idx in x[task.taskId][day]
            ) == task.estimatedDuration
            if task.deadline:
                for day in interval_days:
                    if day >= task.deadline.strftime('%Y-%m-%d'):
                        for idx in x[task.taskId][day]:
                            prob += x[task.taskId][day][idx] == 0

        # Constraint: sum of all tasks in an interval cannot exceed interval length
        for day in interval_days:
            for idx in interval_lengths[day]:
                prob += pulp.lpSum(x[task.taskId][day][idx] for task in tasks) <= interval_lengths[day][idx]

        # For reporting/aggregation, sum up per day
        def sum_task_day(task, day):
            if day in x[task.taskId]:
                return pulp.lpSum(x[task.taskId][day][idx] for idx in x[task.taskId][day])
            return 0
        def sum_all_day(day):
            return pulp.lpSum(
                x[task.taskId][day][idx]
                for task in tasks if day in x[task.taskId]
                for idx in x[task.taskId][day]
            )

        # Redefine A, Yd, cumulative_workload using new sum
        for day in interval_days:
            prob += A[day] == pulp.lpSum(
                sum_task_day(task, day) * task.weight for task in tasks
            )
        for day in interval_days:
            prob += sum_all_day(day) <= sum(interval_lengths[day].values())

        # Objective: update to use sum_task_day
        objective_terms = []
        for task in tasks:
            deadline = task.deadline.date() if task.deadline else None
            for day in interval_days:
                d_date = datetime.fromisoformat(day).date()
                Wd = 1 / (1 + max(0, (deadline - d_date).days)) if deadline else 1.0
                objective_terms.append(sum_task_day(task, day) * Wd * task.weight)
        prob.setObjective(pulp.lpSum(objective_terms) - lambda_penalty * pulp.lpSum(Yd[day] for day in interval_days))

        # The rest of the constraints (cumulative_workload, break days, etc.) remain the same, but use sum_task_day and sum_all_day
        for i, day in enumerate(interval_days):
            if i == 0:
                prob += cumulative_workload[day] == A[day]
            else:
                prev_day = interval_days[i - 1]
                prob += cumulative_workload[day] == cumulative_workload[prev_day] + A[day]
        for day in interval_days:
            prob += cumulative_workload[day] - schedule.workloadThreshold <= M * Yd[day]
            prob += cumulative_workload[day] - schedule.workloadThreshold >= 1 - M * (1 - Yd[day])
            prob += sum_all_day(day) <= (1 - Yd[day]) * M
            prob += cumulative_workload[day] <= M * (1 - Yd[day])

        logger.info("Solving LP problem (interval-based)...")
        prob.solve()
        logger.info("Solved LP with status: %s", pulp.LpStatus[prob.status])

        # Solution extraction: output workload per interval per day
        result_tasks = []
        for task in tasks:
            workload = {}
            for day in interval_days:
                intervals = availableIntervals[day]
                interval_workloads = []
                for idx, (start, end) in enumerate(intervals):
                    val = pulp.value(x[task.taskId][day][idx])
                    if val and val > 0:
                        interval_workloads.append({
                            "interval": [start, end],
                            "workload": round(float(val), 2)
                        })
                if interval_workloads:
                    workload[day] = interval_workloads
            result_tasks.append(OptimizedTask(taskId=task.taskId, taskName=task.taskName, workload=workload))
        return ScheduleResponse(tasks=result_tasks)

    # --- ORIGINAL NON-INTERVAL LOGIC (FOR REFERENCE) ---
    x = {
        task.taskId: {
            day: pulp.LpVariable(f"x_{task.taskId}_{day}", lowBound=0, cat='Continuous') for day in days
        }
        for task in tasks
    }

    A = {day: pulp.LpVariable(f"A_{day}", lowBound=0, cat='Continuous') for day in days}
    Yd = {day: pulp.LpVariable(f"Y_{day}", cat='Binary') for day in days}
    cumulative_workload = {day: pulp.LpVariable(f"C_{day}", lowBound=0, cat='Continuous') for day in days}

    # Objective
    objective_terms = []
    for task in tasks:
        deadline = task.deadline.date() if task.deadline else None
        for day in x[task.taskId]:
            d_date = datetime.fromisoformat(day).date()
            Wd = 1 / (1 + max(0, (deadline - d_date).days)) if deadline else 1.0
            objective_terms.append(x[task.taskId][day] * Wd * task.weight)

    lambda_penalty = 200
    prob += pulp.lpSum(objective_terms) - lambda_penalty * pulp.lpSum(Yd[day] for day in days)

    # Constraints
    for task in tasks:
        prob += pulp.lpSum(x[task.taskId].values()) == task.estimatedDuration
        if task.deadline:
            for day in days:
                if day >= task.deadline.strftime('%Y-%m-%d'):
                    prob += x[task.taskId][day] == 0

    for day in days:
        prob += pulp.lpSum(x[task.taskId].get(day, 0) for task in tasks) <= availableTime[day]

    for day in days:
        prob += A[day] == pulp.lpSum(
            x[task.taskId].get(day, 0) * task.weight for task in tasks
        )

    M = 1000

    for i, day in enumerate(days):
        if i == 0:
            prob += cumulative_workload[day] == A[day]
        else:
            prev_day = days[i - 1]
            prob += cumulative_workload[day] == cumulative_workload[prev_day] + A[day]

    for day in days:
        # Jika workload > threshold, Yd[day] == 1, jika tidak 0
        prob += cumulative_workload[day] - schedule.workloadThreshold <= M * Yd[day]
        prob += cumulative_workload[day] - schedule.workloadThreshold >= 1 - M * (1 - Yd[day])

        # Jika Yd[day] == 1 (break day), maka workload hari itu 0
        prob += pulp.lpSum(x[task.taskId].get(day, 0) for task in tasks) <= (1 - Yd[day]) * M
        prob += cumulative_workload[day] <= M * (1 - Yd[day])

    logger.info("Solving LP problem...")
    prob.solve()
    logger.info("Solved LP with status: %s", pulp.LpStatus[prob.status])


    # Objective value log
    objective_value = pulp.value(prob.objective)
    logger.info("Objective value (schedule optimality score): %.2f", objective_value)

    # Count tasks completed on time
    on_time_tasks = 0
    late_tasks = 0
    for task in tasks:
        if task.deadline:
            last_day = max(
                (day for day in x[task.taskId] if pulp.value(x[task.taskId][day]) > 0),
                default=None
            )
            if last_day:
                if datetime.fromisoformat(last_day).date() <= task.deadline.date():
                    on_time_tasks += 1
                else:
                    late_tasks += 1
        if task.taskType == "daily":
            duration_per_day = task.estimatedDuration / len(days)
            for day in x[task.taskId]:
                prob += x[task.taskId][day] == duration_per_day 


    logger.info("Tasks completed on time: %d", on_time_tasks)
    logger.info("Tasks completed late: %d", late_tasks)

    # Workload per day
    for day in days:
        daily_load = sum(pulp.value(x[task.taskId][day]) or 0 for task in tasks)
        logger.info("Workload on %s: %.2f jam", day, daily_load)

    # Break days (Yd == 1)
    break_days = [day for day in days if pulp.value(Yd[day]) == 1]
    logger.info("Break days (Yd == 1): %s", break_days)

    result_tasks = []
    for task in tasks:
        workload = {
            day: round(float(pulp.value(x[task.taskId][day])), 2)  # convert back ke menit
            for day in x[task.taskId]
            if pulp.value(x[task.taskId][day]) and pulp.value(x[task.taskId][day]) > 0
        }
        result_tasks.append(OptimizedTask(taskId=task.taskId, taskName=task.taskName, workload=workload))

    return ScheduleResponse(tasks=result_tasks)

def _parse_time_to_24h(timestr):
    """
    Parse a time string (e.g., '9:00 PM', '21:00', '09:00') to (hour, minute) in 24h format.
    Returns (hour, minute) as integers.
    """
    import re
    timestr = timestr.strip()
    # Try 24h format first
    m = re.match(r"^(\d{1,2}):(\d{2})$", timestr)
    if m:
        return int(m.group(1)), int(m.group(2))
    # Try 12h format with AM/PM
    m = re.match(r"^(\d{1,2}):(\d{2}) ?([APap][Mm])$", timestr)
    if m:
        hour = int(m.group(1))
        minute = int(m.group(2))
        ampm = m.group(3).lower()
        if ampm == 'pm' and hour != 12:
            hour += 12
        if ampm == 'am' and hour == 12:
            hour = 0
        return hour, minute
    # Try fallback: parse with dateutil
    import dateutil.parser
    dt = dateutil.parser.parse(timestr)
    return dt.hour, dt.minute
