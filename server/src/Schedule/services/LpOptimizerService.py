from typing import Dict, List
from datetime import datetime, timedelta
from pydantic import BaseModel
from fastapi import FastAPI
import calendar
import pulp

app = FastAPI()

class TaskInput(BaseModel):
    taskId: str
    taskName: str
    estimatedDuration: float
    weight: float
    deadline: str  # ISO format
    preferredDays: List[str] = []

class ScheduleRequest(BaseModel):
    daysToSchedule: int
    weeklyWorkHours: Dict[str, float]
    excludedDates: List[str] = []
    tasks: List[TaskInput]
    workloadThreshold: float

class OptimizedTask(BaseModel):
    taskId: str
    taskName: str
    workload: Dict[str, float]

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
    availableTime = generate_available_time(today, schedule.daysToSchedule, schedule.weeklyWorkHours, schedule.excludedDates)
    days = list(availableTime.keys())
    tasks = schedule.tasks

    prob = pulp.LpProblem("Task_Scheduling", pulp.LpMaximize)

    # Variabel x: alokasi waktu untuk tiap task di tiap hari
    x = {
        task.taskId: {
            day: pulp.LpVariable(f"x_{task.taskId}_{day}", lowBound=0, cat='Continuous')
            for day in days if not task.preferredDays or day in task.preferredDays
        }
        for task in tasks
    }

    # Workload harian
    A = {day: pulp.LpVariable(f"A_{day}", lowBound=0, cat='Continuous') for day in days}

    # Akumulasi workload hingga hari ke-d
    C = {day: pulp.LpVariable(f"C_{day}", lowBound=0, cat='Continuous') for day in days}

    # Break day flag (binary)
    b = {day: pulp.LpVariable(f"b_{day}", cat='Binary') for day in days}

    # Objektif: Maksimalkan bobot * kedekatan deadline
    objective_terms = []
    for task in tasks:
        deadline = datetime.fromisoformat(task.deadline).date()
        for day in x[task.taskId]:
            d_date = datetime.fromisoformat(day).date()
            days_to_deadline = (deadline - d_date).days
            Wd = 1 / (1 + max(0, days_to_deadline))
            objective_terms.append(x[task.taskId][day] * Wd * task.weight)

    # Penalti untuk break day (opsional)
    BREAK_PENALTY = 10
    prob += pulp.lpSum(objective_terms) - BREAK_PENALTY * pulp.lpSum(b.values())

    # Constraint: durasi total tiap task
    for task in tasks:
        prob += pulp.lpSum(x[task.taskId].values()) == task.estimatedDuration, f"Duration_{task.taskId}"

    # Constraint: batas waktu per hari
    for day in days:
        prob += pulp.lpSum(
            x[task.taskId].get(day, 0) for task in tasks
        ) <= availableTime[day], f"TimeLimit_{day}"

    # Workload harian A[day]
    for day in days:
        prob += A[day] == pulp.lpSum(
            x[task.taskId].get(day, 0) * task.weight for task in tasks
        ), f"Workload_{day}"

    # Akumulasi workload C[day]
    prob += C[days[0]] == A[days[0]], f"Accumulate_{days[0]}"
    for i in range(1, len(days)):
        prev_day = days[i - 1]
        curr_day = days[i]
        prob += C[curr_day] == C[prev_day] + A[curr_day], f"Accumulate_{curr_day}"

    # Break day aktif jika akumulasi workload melewati threshold
    big_M = 1000
    for day in days:
        prob += C[day] <= schedule.workloadThreshold + big_M * b[day], f"ThresholdWithBreak_{day}"

    # Solve
    prob.solve()

    result_tasks = []
    for task in tasks:
        workload = {
            day: float(pulp.value(x[task.taskId][day]))
            for day in x[task.taskId] if pulp.value(x[task.taskId][day]) and pulp.value(x[task.taskId][day]) > 0
        }
        result_tasks.append(OptimizedTask(taskId=task.taskId, taskName=task.taskName, workload=workload))

    return ScheduleResponse(tasks=result_tasks)
