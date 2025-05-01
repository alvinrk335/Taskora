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

taskRouter.post("/translate", async (req, res) =>{
  const {taskId, taskName, description, priority, type, preferredDays, deadline} = req.body;
  const prompt = `  I am making an optimized schedule using linear programming with some constraints.
                    Please translate this natural language input:
                    - taskId: ${taskId}
                    - taskName: ${taskName}
                    - description: ${description}
                    - priority: ${priority}
                    - taskType: ${type}
                    - preferred non-working days: ${preferredDays}
                    - deadline: ${deadline}

                    Into this JSON format:
                    {
                    "taskId": same as input,
                    "taskName": same as input,
                    "estimatedDuration": <estimated duration as number in hours>,
                    "weight": <importance from 1 to 10, can be decimal>,
                    "deadline": same as input,
                    "preferredDays": same as input
                    }
                `;
  try {
    const response = await axios.post("http://127.0.0.1:8000/ask-gemini", {
      prompt: prompt,
    });
    res.json(response.data.response);
  } catch (error) {
    console.error(error);
    res.status(500).json({error: "Failed to get AI response"});
  }
});
export default taskRouter;

