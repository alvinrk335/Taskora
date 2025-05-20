import { Router } from "express";
import WorkHoursRepository from "../repository/workHoursRepository";
import { WorkHours } from "../entity/WorkHours";

const workHoursRouter = Router();
const repo = new WorkHoursRepository();

workHoursRouter.get("/get/byUid", async (req, res)=>{
    try {
        const uid = req.query.uid as string;
        const workHours = await repo.getWorkHoursByUid(uid);
        return res.status(200).json(workHours.toJson());
    } catch (error) {
        console.error(error)
        return res.status(500).json({"error": error})
    }
})

workHoursRouter.post("/add", async (req, res)=>{
    try {
        const workHoursJson = req.body.workHours;
        const uid = req.body.uid;
        const workHours = WorkHours.fromJson(workHoursJson)

        await repo.addWorkHours(workHours, uid);

        return res.status(200).json({message: "success adding workhours to db"})
    } catch (error) {
        console.error(error)
        return res.status(500).json({"error": error})
    }
})

export default workHoursRouter;