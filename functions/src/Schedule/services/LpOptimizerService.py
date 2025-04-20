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
    preferredDays: List[str] = []  # Optional

class ScheduleRequest(BaseModel):
    availableTime: Dict[str, float]  # {"2025-04-21": 8, ...}
    tasks: List[TaskInput]
    workloadThreshold: float  # threshold beban kerja harian (dikalikan weight)

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

    prob = pulp.LpProblem("Task_Scheduling", pulp.LpMinimize)

    # Variables: x[taskId][day] = time allocated
    x = {
        task.taskId: {
            day: pulp.LpVariable(f"x_{task.taskId}_{day}", lowBound=0, cat='Continuous')
            for day in days
            if not task.preferredDays or day in task.preferredDays
        }
        for task in tasks
    }

    # Break day binary variable
    b = {
        day: pulp.LpVariable(f"b_{day}", cat='Binary')
        for day in days
    }

    # Objective: Minimize weighted total load near deadline with priority
    objective_terms = []
    for task in tasks:
        deadline = datetime.fromisoformat(task.deadline)
        for day in x[task.taskId]:
            d_date = datetime.fromisoformat(day)
            days_to_deadline = (deadline - d_date).days
            Wd = 11 + max(0, -days_to_deadline)
            objective_terms.append(x[task.taskId][day] * task.weight * Wd)

    prob += pulp.lpSum(objective_terms)

    # Constraint: Total task duration must be met
    for task in tasks:
        prob += pulp.lpSum(x[task.taskId].values()) == task.estimatedDuration, f"Dur_{task.taskId}"

    # Constraint: Total time per day must not exceed available time
    for day in days:
        prob += pulp.lpSum(
            x[task.taskId][day] for task in tasks if day in x[task.taskId]
        ) <= schedule.availableTime[day], f"DayCap_{day}"

    # Define weighted workload per day
    daily_workload = {
        day: pulp.lpSum(
            x[task.taskId][day] * task.weight for task in tasks if day in x[task.taskId]
        )
        for day in days
    }

    # Enforce break day: if break day, no work that day
    for day in days:
        prob += daily_workload[day] <= schedule.availableTime[day] * (1 - b[day]), f"Break_zero_work_{day}"

    # If workload > threshold today, then tomorrow is break day
    threshold = 15  # example threshold
    big_M = 1000

    for i in range(len(days) - 1):
        today = days[i]
        next_day = days[i + 1]
        prob += daily_workload[today] - threshold <= (1 - b[next_day]) * big_M, f"Trigger_break_{today}_to_{next_day}"

    # Solve
    prob.solve()

    # Collect result
    schedule_id = str(uuid.uuid4())
    result_tasks = []
    for task in tasks:
        workload = {
            day: float(pulp.value(x[task.taskId][day]))
            for day in x[task.taskId]
            if pulp.value(x[task.taskId][day]) > 0
        }
        result_tasks.append(OptimizedTask(taskId=task.taskId, taskName=task.taskName, workload=workload))

    return ScheduleResponse(scheduleId=schedule_id, tasks=result_tasks)