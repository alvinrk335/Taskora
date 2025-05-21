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
            
<<<<<<< HEAD
=======
            if (!workHoursDoc.exists) {
                console.log(`work hour is not found for this uid`);
            }
            
>>>>>>> master
            return WorkHours.fromJson(workHours);
        } catch (error) {
            console.error(error)
            throw new Error("error getting work hours")
        }
    }
}