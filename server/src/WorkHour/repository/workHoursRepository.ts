import admin from "../../firebase";
import { WorkHours } from "../entity/WorkHours";

const db = admin.firestore();
export default class WorkHoursRepository{
    private workHourCollection = db.collection("workhours");

    async addWorkHours(workHours: WorkHours, uid: string): Promise<void>{
        try {
            await this.workHourCollection.doc(uid).set(workHours.toJson());
        } catch (error) {
            console.error(error)
            throw new Error("error adding work hours into db")
        }
    }

    async getWorkHoursByUid(uid: string): Promise<WorkHours>{
        try {
            const workHoursDoc = await this.workHourCollection.doc(uid).get();
            const workHours = workHoursDoc.data();
            
            if (!workHoursDoc.exists) {
                console.log(`work hour is not found for this uid`);
            }
            
            return WorkHours.fromJson(workHours);
        } catch (error) {
            console.error(error)
            throw new Error("error getting work hours")
        }
    }

    async updateWorkHoursInterval(uid: string, dayName: string, intervals: {start: string, end: string}[]): Promise<void> {
        try {
            const workHoursDoc = await this.workHourCollection.doc(uid).get();
            if (!workHoursDoc.exists) throw new Error("work hours not found");
            const workHours = WorkHours.fromJson(workHoursDoc.data());
            const updated = workHours.update(dayName, intervals);
            await this.workHourCollection.doc(uid).set(updated.toJson());
        } catch (error) {
            console.error(error);
            throw new Error("error updating work hours interval");
        }
    }
}