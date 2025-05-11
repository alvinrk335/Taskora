from fastapi.testclient import TestClient
from datetime import datetime
from LpOptimizerService import app

client = TestClient(app)

def test_optimize_schedule():
    response = client.post("/optimizeSchedule", json={
        "daysToSchedule": 100,
        "weeklyWorkingHours": {
            "Monday": 3,
            "Tuesday": 3,
            "Wednesday": 5,
            "Thursday": 6,
            "Friday": 4,
            "Saturday": 0,
            "Sunday": 2
        },
        "excludedDates": [],
        "workloadThreshold": 6,
        "tasks": [
            {
                "taskId": "1",
                "taskName": "Task A",
                "estimatedDuration": 120,
                "weight": 0.8,
                "deadline": "2025-06-13T00:00:00+00:00",
            },
            {
                "taskId": "2",
                "taskName": "Task B",
                "estimatedDuration": 400,
                "weight": 0.7,
                "deadline": "2025-06-3T00:00:00+00:00",
            },
            {
                "taskId": "3",
                "taskName": "Task C",
                "estimatedDuration": 7200,
                "weight": 0.8,
                "deadline": "2025-06-23T00:00:00+00:00",
            }

        ]
    })

    assert response.status_code == 200
    data = response.json()
    print(f"data :{data}")
    assert "tasks" in data
    assert len(data["tasks"]) == 2
    assert "workload" in data["tasks"][0]
