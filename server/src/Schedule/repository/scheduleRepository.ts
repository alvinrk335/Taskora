import admin from "../../firebase";

import Schedule from "../entity/Schedule";

const db = admin.firestore();
export default class scheduleRepository {
  private scheduleCollection = db.collection("schedules");

  async addSchedule(schedule: Schedule, uid: string): Promise<void> {
    try {
      const scheduleId = schedule.getScheduleId();

      for (const task of schedule.getTasks()) {
        await task;
        const taskId = task.getTaskId();
        const docId = `${scheduleId}_${taskId}`;

        await this.scheduleCollection.doc(docId).set({
          scheduleId,
          taskId,
          uid,
        });
      }
    } catch (error) {
      console.error(error);
    }
  }

  async addScheduleWithTask(schedule: Schedule, uid: string): Promise<void>{
    try {
      await db.runTransaction(async (transaction) => {
      const scheduleId = schedule.getScheduleId();

      for (const task of schedule.getTasks()) {
        const taskId = task.getTaskId();
        const docId = `${scheduleId}_${taskId}`;
        const docRef= this.scheduleCollection.doc(docId);

        const taskRef = db.collection("tasks").doc(taskId);

        transaction.set(docRef, {
          scheduleId,
          taskId,
          uid,
        });

        transaction.set(taskRef, task.toJSON(), {merge: true});
      }

      })
    } catch (error) {
      console.error(error)
    }
  }

  async getSchedule(scheduleId: string): Promise<{ scheduleId: string; taskIds: string[] }> {
    try {
      const snapshot = await this.scheduleCollection.where("scheduleId", "==", scheduleId).get();
      const taskIds = snapshot.docs.map((doc) => doc.data().taskId);

      return {
        scheduleId: scheduleId,
        taskIds: taskIds,
      };
    } catch (error) {
      console.error(error);
      throw new Error("error fetching schedule data");
    }
  }

  async deleteTaskInSchedule(scheduleId: string, taskId:any): Promise<void> {
    try {
      const docId = `${scheduleId}_${taskId}`;
      await this.scheduleCollection.doc(docId).delete();
      console.log(`Deleted schedule entry ${docId}`);
    } catch (error) {
      console.error(error);
    }
  }

  async addTaskToSchedule(scheduleId: string, taskId: string, uid: string): Promise<void>{
    try {
      const docId = `${scheduleId}_${taskId}`;
      await this.scheduleCollection.doc(docId).set({
        scheduleId,
        taskId,
        uid,
      });
    } catch (error) {
      console.error(error)
    }
  }
  async deleteWholeSchedule(scheduleId: string): Promise<void> {
    try {
      const snapshot = await this.scheduleCollection
        .where("scheduleId", "==", scheduleId)
        .get();

      if (snapshot.empty) {
        console.log("No documents found to delete.");
        return;
      }

      const batch = db.batch();

      snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();
      console.log(`Schedule with ID ${scheduleId} deleted successfully.`);
    } catch (error) {
      console.error("Error deleting schedule:", error);
    }
  }

  async findSchedule(scheduleId: string): Promise<boolean> {
    try {
      const snapshot = await this.scheduleCollection.where("scheduleId", "==", scheduleId).get();
      return !snapshot.empty;
    } catch (error) {
      console.error(error);
      return false;
    }
  }

  async getScheduleByUid(uid: string): Promise<{ scheduleId: string; taskIds: string[] } |null>{
    try {
      const snapshot = await this.scheduleCollection.where("uid", "==", uid).get();
      if (snapshot.empty) {
        return null;
      }
      const taskIds = snapshot.docs.map((doc) => doc.data().taskId);
      const scheduleId = snapshot.docs[0].data().scheduleId;
      return {
        scheduleId,
        taskIds,
      };
    } catch (error) {
      console.error(error)
      throw new Error("error fetching schedule data");
    }
  }
  async removeScheduleWithTask(schedule: Schedule){
    try {
      await db.runTransaction(async(transaction) => {
        const scheduleId = schedule.getScheduleId();
        for(const task of schedule.getTasks()){
          const taskId = task.getTaskId();
          const docId = `${scheduleId}_${taskId}`;
          const docRef= this.scheduleCollection.doc(docId);

          const taskRef = db.collection("tasks").doc(taskId);

          transaction.delete(docRef);

          transaction.delete(taskRef);
        }
      })
    } catch (error) {
      console.error(error)
      throw new Error("error removing schedule data");
    }
  }

}
