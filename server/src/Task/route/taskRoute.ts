import {Router} from "express";
import taskRepository from "../repository/taskRepository";
import axios from "axios";
import Task from "../entity/Task";

const repo = new taskRepository();
const taskRouter = Router();

taskRouter.get("/getById", async (req, res) =>{
  try {
    const taskId = req.query.taskId as string;
    if (!taskId) {
      return res.status(400).json({error: "taskId is required"});
    }

    const task = await repo.getTask(taskId);
    if (!task) {
      return res.status(404).json({error: "Task not found"});
    }

    return res.json(task.toJSON());
  } catch (error) {
    console.error(error);
    return res.status(500).json({error: "error fetching task"});
  }
});

taskRouter.post("/add", async (req, res) => {
  try {
    const task = req.body;
    const repoTask = Task.fromJSON(task);
    await repo.addTask(repoTask);
    res.status(201).json({message: "Task added successfully", task: repoTask.toJSON()});
  } catch (error) {
    console.error(error);
    res.status(500).json({error: "error adding task"});
  }
});

taskRouter.put("/edit", async (req, res) => {
  try {
    const data = req.body.task;

    if (!data.taskId) {
      return res.status(400).json({error: "taskId is required"});
    }

    const task = Task.fromJSON(data);

    await repo.setTask(data.taskId, task);

    return res.status(200).json({message: `task ${task.getTaskName()} updated sucessfully`});
  } catch (error) {
    console.error(error);
    return res.status(500).json({error: "error updating data"});
  }
});

taskRouter.post("/translate", async (req, res) => {
  const { listOfTask } = req.body;

  if (!Array.isArray(listOfTask)) {
    return res.status(400).json({ error: "listOfTask must be an array" });
  }

  try {
    const translatedTasks = await Promise.all(
      listOfTask.map(async (task) => {
        const prompt = `
            I am making an optimized schedule using linear programming with some constraints.
            Please translate this natural language input:
            - taskId: ${task.taskId}
            - taskName: ${task.taskName}
            - description: ${task.description}
            - priority: ${task.priority}
            - taskType: ${task.type}
            - deadline: ${task.deadline}

            Into this JSON format:
            {
              "taskId": same as input,
              "taskName": same as input,
              "estimatedDuration": <estimated duration as number in hours>,
              "weight":  <importance as a decimal between 0 and 1>,
              "deadline": same as input
            }
            `;

        const response = await axios.post("http://127.0.0.1:8000/ask-gemini", {
          prompt,
        });

        return response.data.response; // Harus JSON-parsable
      })
    );

    return res.json({ translatedTasks });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Failed to translate tasks" });
  }
});
export default taskRouter;

