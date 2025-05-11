import request from "supertest";
import app from ".";

describe("POST /schedule/optimize", () => {
  it("should return 400 if required fields are missing", async () => {
    const res = await request(app)
      .post("/schedule/optimize")
      .send({}); // kirim kosong

    expect(res.statusCode).toBe(400);
    expect(res.body.error).toMatch(/Missing required fields/);
  });

  it("should return 200 with proper input (mocked response)", async () => {
    // Di sini bisa mock translateTasks dan axios.post jika perlu
    const validBody = {
      scheduleId: "SCH001",
      listOfTask: [
        {
          taskId: "TA001",
          taskName: "Task 1",
          description: "make app MVP (half done)",
          priority: 3,
          taskType: "Project",
          deadline: "2025-05-31T00:00:00.000Z"
        },
        {
          taskId: "TA002",
          taskName: "Task 2",
          description: "refactor online found code",
          priority: 2,
          taskType: "Project",
          deadline: "2025-06-7T00:00:00.000Z"
        }
      ],
      weeklyWorkingHours: {            
            "Monday": 4,
            "Tuesday": 2,
            "Wednesday": 3,
            "Thursday": 4,
            "Friday": 0,
            "Saturday": 5,
            "Sunday": 0
        },
      excludedDates: [],
      daysToSchedule: 100,
      workloadThreshold: 10
    };

    const res = await request(app)
      .post("/schedule/optimize")
      .send(validBody);

    expect(res.statusCode).toBe(200);
    // expect(res.body).toHaveProperty("tasks"); // disesuaikan
  });
});
