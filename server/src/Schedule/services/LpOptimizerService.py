from typing import Dict, List
from datetime import datetime
from pydantic import BaseModel
from fastapi import FastAPI
import uuid
import pulp

app = FastAPI()

class TaskInput(BaseModel):
    taskId: str
    taskName: str
    estimatedDuration: float
    weight: float
    deadline: str  # ISO format date string
    preferredDays: List[str] = []

class ScheduleRequest(BaseModel):
    availableTime: Dict[str, float]  # {"2025-04-21": 8, ...}
    tasks: List[TaskInput]
    workloadThreshold: float

class OptimizedTask(BaseModel):
    taskId: str
    taskName: str
    workload: Dict[str, float]  # {"2025-04-21": 2, ...}

class ScheduleResponse(BaseModel):
    scheduleId: str
    tasks: List[OptimizedTask]

@app.post("/optimizeSchedule", response_model=ScheduleResponse)
def optimize_schedule(schedule: ScheduleRequest):
    days = list(schedule.availableTime.keys())
    tasks = schedule.tasks

    prob = pulp.LpProblem("Task_Scheduling", pulp.LpMaximize)

    x = {
        task.taskId: {
            day: pulp.LpVariable(f"x_{task.taskId}_{day}", lowBound=0, cat='Continuous')
            for day in days if not task.preferredDays or day in task.preferredDays
        }
        for task in tasks
    }

    b = {day: pulp.LpVariable(f"b_{day}", cat='Binary') for day in days}

    A = {day: pulp.LpVariable(f"A_{day}", lowBound=0, cat='Continuous') for day in days}

    # Objective: Maximize task importance Wd = 1 / (1 + (di - d))
    objective_terms = []
    for task in tasks:
        deadline = datetime.fromisoformat(task.deadline)
        for day in x[task.taskId]:
            d_date = datetime.fromisoformat(day)
            days_to_deadline = (deadline - d_date).days
            Wd = 1 / (1 + max(0, days_to_deadline))
            objective_terms.append(x[task.taskId][day] * Wd * task.weight)

    prob += pulp.lpSum(objective_terms)

    # Constraint: each task must be fully scheduled
    for task in tasks:
        prob += pulp.lpSum(x[task.taskId].values()) == task.estimatedDuration, f"Duration_{task.taskId}"

    # Constraint: time available each day
    for day in days:
        prob += pulp.lpSum(
            x[task.taskId][day] for task in tasks if day in x[task.taskId]
        ) <= schedule.availableTime[day], f"TimeLimit_{day}"

    # Daily workload = sum of weight * time
    for day in days:
        prob += A[day] == pulp.lpSum(
            x[task.taskId][day] * task.weight for task in tasks if day in x[task.taskId]
        ), f"Workload_{day}"

    # Constraint: break day if needed
    big_M = 1000
    for i, day in enumerate(days):
        if i == 0:
            continue
        prev_day = days[i - 1]
        prob += A[day] >= A[prev_day] + pulp.lpSum(
            x[task.taskId][day] * task.weight for task in tasks if day in x[task.taskId]
        ) - big_M * b[day], f"Acc_Lower_{day}"
        prob += A[day] <= A[prev_day] + pulp.lpSum(
            x[task.taskId][day] * task.weight for task in tasks if day in x[task.taskId]
        ) + big_M * b[day], f"Acc_Upper_{day}"

    # Constraint: workload threshold
    for day in days:
        prob += A[day] <= schedule.workloadThreshold, f"Threshold_{day}"

    # Solve
    prob.solve()

    schedule_id = str(uuid.uuid4())
    result_tasks = []
    for task in tasks:
        workload = {
            day: float(pulp.value(x[task.taskId][day]))
            for day in x[task.taskId] if pulp.value(x[task.taskId][day]) > 0
        }
        result_tasks.append(OptimizedTask(taskId=task.taskId, taskName=task.taskName, workload=workload))

    return ScheduleResponse(scheduleId=schedule_id, tasks=result_tasks)
