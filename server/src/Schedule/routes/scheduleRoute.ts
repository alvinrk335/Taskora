import {Router} from "express";
import axios from "axios";
import Schedule from "../entity/Schedule";
import {Timestamp} from "firebase-admin/firestore";
import Task from "../../Task/entity/Task";
import scheduleRepository from "../repository/scheduleRepository";

const scheduleRouter = Router();
const repo = new scheduleRepository();

scheduleRouter.post("/schedule/optimize", async (req, res)=> {
  try {
    const listOfTask = req.body;

    if (!listOfTask) {
      return res.status(300).json({error: "list of task is required"});
    }

    const optimize = await axios.post("http://127.0.0.1:8001/optimizeSchedule", {
      listOfTask,
    });

    if (!optimize) {
      return res.status(300).json({error: "error connecting to optimizer service"});
    }

    const scheduleStart = Timestamp.now();
    const tasks = optimize.data.tasks.map((taskJson: any) => Task.fromJSON(taskJson));

    // Urutkan berdasarkan deadline
    tasks.sort((a: Task, b: Task) => a.getDeadline().getTime() - b.getDeadline().getTime());

    // Ambil task terakhir yang deadline-nya paling lama
    const lastTask = tasks[tasks.length - 1];
    const scheduleEnd = lastTask.getDeadline();

    const schedule = new Schedule({
      scheduleId: optimize.data.scheduleId,
      tasks: tasks,
      scheduleStart: scheduleStart,
      scheduleEnd: scheduleEnd,
    });

    return res.status(200).json(schedule.toJSON());
  } catch (error) {
    console.error(error);
    return res.status(500).json(error);
  }
});

scheduleRouter.post("/schedule/add", async (req, res) => {
  try {
    const {uid, schedule} = req.body;
    if (!uid || !schedule) {
      return res.status(400).json({error: "uid and schedule are required"});
    }
    const scheduleInstance = Schedule.fromJSON(schedule);
    await repo.addSchedule(scheduleInstance, uid);

    return res.json({message: "success adding schedule"});
  } catch (error) {
    console.error(error);
    return res.status(500).json({error: "error adding schedule to database"});
  }
});

export default scheduleRouter;
