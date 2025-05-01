import {response, Router} from "express";
import axios from "axios";
import Schedule from "../entity/Schedule";
import {Timestamp} from "firebase-admin/firestore";
import Task from "../../Task/entity/Task";
import scheduleRepository from "../repository/scheduleRepository";
import Name from "../../Task/entity/value_object/Name";
import Description from "../../Task/entity/value_object/Description";
import taskType from "../../Task/entity/value_object/TaskType";
import Duration from "../../Task/entity/value_object/Duration";
import optimizedTask from "../../Task/entity/optimizedTask";
import TranslatedTask from "../../Task/entity/translatedTask";
import initialTask from "../../Task/entity/initialTask";

const scheduleRouter = Router();
const repo = new scheduleRepository();

scheduleRouter.post("/optimize", async (req, res)=> {
  try {
    const listOfTask = req.body.listOfTask; // initialTask

    if (!listOfTask) {
      return res.status(300).json({error: "list of task is required"});
    }
    const translateResponse = await axios.post("http://localhost:3000/task/translate", {
      listOfTask,
    });

    const translatedTasks = translateResponse.data.translatedTasks;//translatedTask
    if (!translatedTasks || !Array.isArray(translatedTasks)) {
      return res.status(500).json({ error: "Invalid response from translation service" });
    }
    const optimizeResponse = await axios.post("http://localhost:8001/optimizeSchedule", {
      listOfTask: translatedTasks,
    });

    const optimizedData = optimizeResponse.data;//optimizedTask
    if (!optimizedData || !Array.isArray(optimizedData.tasks)) {
      return res.status(500).json({ error: "Invalid response from optimization service" });
    }

    const initialTasksModel: initialTask[] = listOfTask.map((task: any) => new initialTask(
      task.taskId,
      Name.fromString(task.taskName),
      Description.fromString(task.description),
      task.priority,
      taskType.fromString(task.taskType),
      (task.preferredDays ?? []).map((d: string) => new Date(d)),
      task.deadline ? new Date(task.deadline) : undefined
    ));
    
    const translatedTasksModel: TranslatedTask[] = translatedTasks.map((task: any) => 
      new TranslatedTask(
        task.taskId,
        Name.fromString(task.taskName),
        Duration.fromNumber(task.estimatedDuration),
        task.weight,
        new Date(task.deadline),
        (task.preferredDays ?? []).map((d: string) => new Date(d))
      )
    );
    
    const optimizedTasksModel: optimizedTask[] = optimizeResponse.data.tasks.map((task: any) => 
      optimizedTask.fromJSON(task)
    );

    const tasks: Task[] = optimizedTasksModel.map((opt) => {
      const taskId = opt.getTaskId();
    
      const translated = translatedTasksModel.find(t => t.getTaskId() === taskId);
      if (!translated) throw new Error(`Translated task not found for ID ${taskId}`);
    
      const initial = initialTasksModel.find(t => t.getTaskId() === taskId);
      if (!initial) throw new Error(`Initial task not found for ID ${taskId}`);
    
      return new Task({
        taskId: taskId,
        taskName: opt.getTaskName(), 
        description: initial.getDescription(),
        priority: initial.getPriority(),
        type: initial.getType(),
        preferredDays: translated.getPreferredDays(),
        deadline: translated.getDeadline(),
        weight: translated.getWeight(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        workload: opt.getWorkload(),
        estimatedDuration: translated.getEstimatedDuration(),
      });
    });

    const scheduleStart = Timestamp.now();
    tasks.sort((a: Task, b: Task) => a.getDeadline().getTime() - b.getDeadline().getTime());

    // const lastTask = tasks[tasks.length - 1];
    // const scheduleEnd = lastTask.getDeadline();

    const schedule = new Schedule({
      scheduleId: optimizeResponse.data.scheduleId,
      tasks: tasks,
      scheduleStart: scheduleStart,
    });

    return res.status(200).json(schedule.toJSON());
  } catch (error) {
    console.error(error);
    return res.status(500).json(error);
  }
});

scheduleRouter.get("/get", async (req, res) => {
  try {
    const scheduleId = req.query.scheduleId as string;

    const schedule = await repo.getSchedule(scheduleId);

    return res.status(200).json(schedule);
  } catch (error) {
    console.error(error)
    return res.status(500).json({error: "error getting schedule from database"});
  }
})

scheduleRouter.post("/add", async (req, res) => {
  try {
    const scheduleJson = req.body.schedule
    const schedule = Schedule.fromJSON(scheduleJson)
    const uid = req.body.uid

    await repo.addSchedule(schedule, uid)
    return res.status(200).json({ message: "Successfully added schedule" });

  } catch (error) { 
    console.error(error)
    return res.status(500).json({error: "error adding schedule to database"})
  }
})


scheduleRouter.put("/addTask", async (req, res) => {
  try {
    const {scheduleId, taskId, uid} = req.body
    await repo.addTaskToSchedule(scheduleId, taskId, uid)
    return res.status(200).json({message: `success adding task ${taskId} to schedule ${scheduleId}`})

  } catch (error) {
    console.error(error)
    return res.status(500).json({error: "error editing schedule to database"})
  }
})

scheduleRouter.delete("/deleteTask", async (req, res) => {
  try {
    const {scheduleId, taskId} = req.body
    await repo.deleteTaskInSchedule(scheduleId, taskId)
    return res.status(200).json({message: `success deleting task ${taskId} to schedule ${scheduleId}`})
  } catch (error) {
    console.error(error)
    return res.status(500).json({error: "error editing schedule to database"})
  }
})

scheduleRouter.get("/getByUid", async (req, res ) => {
  try {
    const uid = req.query.uid as string;
    const response = await repo.getScheduleByUid(uid);
    if(response == null){
      return res.status(300).json("schedule not found with this uid")
    }
    res.status(200).json(response);
  } catch (error) {
    console.error(error)
    return res.status(500).json({error: "error getting schedule to database"})
  }
})
export default scheduleRouter;
