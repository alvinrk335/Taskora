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
import translateTasks from "../services/translateTask";
import reOptimize from "../services/reoptimize";
import { checkCompliance } from "../services/checkConstraintCompliance";

const scheduleRouter = Router();
const repo = new scheduleRepository();



scheduleRouter.post("/optimize", async (req, res)=> {
  try {
    console.log(`input received: ${JSON.stringify(req.body, null, 2)}`)
    const tStart = Date.now();
    const {
      request,
      scheduleId,
      listOfTask,
      weeklyWorkingHours,
      excludedDates,
      daysToSchedule,
      workloadThreshold,
    } = req.body; // initialTask

    if (!weeklyWorkingHours || !excludedDates || !daysToSchedule || !workloadThreshold || !listOfTask) {
      return res.status(400).json({ error: "Missing required fields" });
    }
    const listInitialTask = listOfTask.map((task: any) => {
      const taskInstance = initialTask.fromJSON(task); 
      taskInstance.changeDateFormat("string");
      return taskInstance;
    });
    console.log(`input sent to llm service ${JSON.stringify(listInitialTask, null, 2)}`)

    const translateResponse = await translateTasks( listInitialTask);

    const translatedTasks = translateResponse//translatedTask
    if (!translatedTasks || !Array.isArray(translatedTasks)) {
      return res.status(500).json({ error: "Invalid response from translation service" });
    }

    console.log("input to optimizer service:", JSON.stringify({
      tasks: translatedTasks,
      weeklyWorkingHours,
      excludedDates,
      daysToSchedule,
      workloadThreshold
    }, null, 2));

    const optimizeResponse = await axios.post("http://optimizer:8000/optimizeSchedule", {
      tasks: translatedTasks,
      weeklyWorkingHours,
      excludedDates,
      daysToSchedule,
      workloadThreshold
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
      task.deadline ? new Date(task.deadline) : undefined
    ));
    
    const translatedTasksModel: TranslatedTask[] = translatedTasks.map((task: any) => 
      new TranslatedTask(
        task.taskId,
        Name.fromString(task.taskName),
        Duration.fromMinutes(task.estimatedDuration),
        task.weight,
        task.deadline ? new Date(task.deadline) : undefined
      )
    );
    
    const optimizedTasksModel: optimizedTask[] = optimizedData.tasks.map((task: any) => 
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
        deadline: translated.getDeadline() !== null ? translated.getDeadline() as Date : null,
        weight: translated.getWeight(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        workload: opt.getWorkload(),
        estimatedDuration: translated.getEstimatedDuration(),
      });
    });

    const scheduleStart = Timestamp.now();
    tasks.sort((a: Task, b: Task) =>  {
      const aDeadline = a.getDeadline();
      const bDeadline = b.getDeadline();

      if(!aDeadline && !bDeadline) return 0;
      if(!aDeadline) return 1;
      if(!bDeadline) return -1;

      return new Date(aDeadline).getTime() - new Date(bDeadline).getTime();
    }

    );

    // const lastTask = tasks[tasks.length - 1];
    // const scheduleEnd = lastTask.getDeadline();
    console.log(scheduleId)
    let schedule = new Schedule({
      scheduleId: scheduleId,
      tasks: tasks,
      scheduleStart: scheduleStart,
    });

    if(request && request.trim() !== ""){
      const updatedScheduleJson = await reOptimize(schedule, request, weeklyWorkingHours);
      schedule = Schedule.fromJSON(updatedScheduleJson);
    }
    //log scheduling time
    const tEnd = Date.now();
    const durationMs = tEnd - tStart;
    const durationSec = (durationMs / 1000).toFixed(2);
    console.log(`Schedule generation completed in ${durationMs} ms (${durationSec} seconds)`);

    //log constraint compliance
    const rawTasks = schedule.getTasks(); // Task[]
    const complianceInput = rawTasks.map(task => task.toComplianceFormat());
    const complianceResults = checkCompliance(complianceInput);
    console.log(complianceResults)

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

scheduleRouter.post("/add/withTask", async (req, res) => {
  try {
    const scheduleJson = req.body.schedule;
    const schedule = Schedule.fromJSON(scheduleJson);
    const uid = req.body.uid;
    console.log(`[ADD WITH TASK] gets : ${JSON.stringify(schedule.toJSON())}`);
    await repo.addScheduleWithTask(schedule, uid)
    return res.status(200).json({message: `success adding schedule ${JSON.stringify(schedule.toJSON())}`})
  } catch (error) {
    console.error(error)
    return res.status(500).json({error: "error adding schedule and task"})
  }
})

scheduleRouter.post("/remove/withTask", async(req, res) => {
  try {
      const scheduleJson = req.body.schedule;
      const schedule = Schedule.fromJSON(scheduleJson);

      console.log(`[REMOVE WITH TASK] gets : ${JSON.stringify(schedule.toJSON())}`);
    
      await repo.removeScheduleWithTask(schedule);
      return res.status(200).json({message: `success removing schedule ${schedule.getScheduleId} from db`})
  } catch (error) {
    console.error(error)
    return res.status(500).json({error: "error removing schedule"});
  }

})

export default scheduleRouter;
