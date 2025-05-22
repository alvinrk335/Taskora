import {Router} from "express";
import taskRepository from "../repository/taskRepository";
import Task from "../entity/Task";
import translateTasks from "../../Schedule/services/translateTask";

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

    return res.status(200).json(task.toJSON());
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
    res.status(200).json({message: "Task added successfully", task: repoTask.toJSON()});
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

    await repo.setTask(task.getTaskId(), task.toJSON());

    return res.status(200).json({message: `task ${task.getTaskName()} updated sucessfully`});
  } catch (error) {
    console.error(error);
    return res.status(500).json({error: "error updating data"});
  }
});

taskRouter.post("/translate", async (req, res) => {
  const listOfTask = req.body.listOfTask;

  try {
    const translatedTasks = await translateTasks(listOfTask);
    return res.json({ translatedTasks });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Failed to translate tasks" });
  }
});
export default taskRouter;

