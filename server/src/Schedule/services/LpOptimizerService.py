from typing import Dict, List, Optional
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
    weeklyWorkingHours: Dict[str, float]  # Input in minutes per day name
    excludedDates: List[datetime] = []
    tasks: List[TaskInput]
    workloadThreshold: float  # Input in minutes


class OptimizedTask(BaseModel):
    taskId: str
    taskName: str
    workload: Dict[str, float]  # Output in minutes

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

@app.post("/optimizeSchedule", response_model=ScheduleResponse)
def optimize_schedule(schedule: ScheduleRequest):
    today = datetime.now().date()
    logger.info("Received schedule request with %d tasks", len(schedule.tasks))

    # Convert estimatedDuration dari menit ke jam
    for task in schedule.tasks:
        task.estimatedDuration /= 60.0  # menit → jam

    availableTime = generate_available_time(today, schedule.daysToSchedule, schedule.weeklyWorkingHours, [d.strftime('%Y-%m-%d') for d in schedule.excludedDates])
    logger.info("Generated available time slots for %d days", len(availableTime))

    days = list(availableTime.keys())
    tasks = schedule.tasks

    prob = pulp.LpProblem("Task_Scheduling", pulp.LpMaximize)
    logger.info("Initialized LP problem")

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
                if day > task.deadline.strftime('%Y-%m-%d'):
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
        prob += pulp.lpSum(x[task.taskId].get(day, 0) for task in tasks) <= (1 - Yd[day]) * 1000
        prob += cumulative_workload[day] <= M * (1 - Yd[day])

    logger.info("Solving LP problem...")
    prob.solve()
    logger.info("Solved LP with status: %s", pulp.LpStatus[prob.status])

    result_tasks = []
    for task in tasks:
        workload = {
            day: round(float(pulp.value(x[task.taskId][day])), 2)  # convert back ke menit
            for day in x[task.taskId]
            if pulp.value(x[task.taskId][day]) and pulp.value(x[task.taskId][day]) > 0
        }
        result_tasks.append(OptimizedTask(taskId=task.taskId, taskName=task.taskName, workload=workload))

    return ScheduleResponse(tasks=result_tasks)
