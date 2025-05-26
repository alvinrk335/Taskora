const axios = require('axios');

const scheduleOptimizeTest = async () => {
  const now = new Date();
  const futureDate = (days) => {
    const d = new Date(now);
    d.setDate(d.getDate() + days);
    return d.toISOString();
  };

  const tasks = [
    {
      taskId: "task-001",
      taskName: "Software Engineering Project",
      description: "Make a simple scheduling app with core optimizer service already exist",
      taskType: "Project",
      deadline: futureDate(40),
      priority: "High"
    },
    {
      taskId: "task-002",
      taskName: "Make Optimizer Service",
      description: "Make core optimizer module for scheduling system using LP",
      taskType: "Project",
      deadline: futureDate(20),
      priority: "High"
    },
     {
      taskId: "task-003",
      taskName: "do leetcode daily",
      description: "do leetcode daily problem",
      taskType: "daily",
      deadline: null,
      priority: "Low"
    },
    {
      taskId: "task-004",
      taskName: "Agile assignment",
      description: "answer some questions about scrum framework",
      taskType: "assignment",
      deadline: futureDate(7),
      priority: "Low"
    },
    {
      taskId: "task-005",
      taskName: "Code documentation",
      description: "make a code documentation for a simple application",
      taskType: "other",
      deadline: futureDate(35),
      priority: "Medium"
    }
  ];
  const weeklyWorkingHours = {
    Monday: 4.0,
    Tuesday: 3.0,
    Wednesday: 0.0,
    Thursday: 5.0,
    Friday: 2.0,
    Saturday: 2.0,
    Sunday: 0.0
  };

  const payload = {
    request: "",
    scheduleId: "schedule-001",
    listOfTask: tasks,
    weeklyWorkingHours: weeklyWorkingHours,
    excludedDates: [],
    daysToSchedule: 40,
    workloadThreshold: 8
  };

  try {
    const res = await axios.post("http://localhost:3000/schedule/optimize", payload);
    console.log("✅ Schedule created successfully:");
    console.dir(res.data, { depth: null });
  } catch (error) {
    console.error("❌ Failed to optimize schedule:");
    if (error.response) {
      console.error(error.response.data);
    } else {
      console.error(error.message);
    }
  }
};

scheduleOptimizeTest();
