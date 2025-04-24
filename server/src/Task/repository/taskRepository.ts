import Task from "../entity/Task";
import admin from "../../firebase";

const db = admin.firestore();
export default class taskRepository {
  private taskCollection = db.collection("tasks");

  async addTask(task: Task): Promise<void> {
    const finalTask = task.toJSON();
    try {
      await this.taskCollection.doc(task.getTaskId()).set(finalTask);
    } catch (error) {
      console.error(error);
    }
  }

  async getTask(taskId: string): Promise<Task> {
    try {
      const task = await this.taskCollection.doc(taskId).get();
      return Task.fromJSON(task);
    } catch (error) {
      console.error(error);
      throw new Error("error getting task");
    }
  }

  async setTask(taskId: string, data: Partial<Task>): Promise<void> {
    try {
      await this.taskCollection.doc(taskId).update(data);
    } catch (error) {
      console.error(error);
    }
  }

  async deleteTask(taskId: string): Promise<void> {
    try {
      await this.taskCollection.doc(taskId).delete();
    } catch (error) {
      console.error(error);
    }
  }

  async findTask(taskId: string): Promise<boolean> {
    try {
      const doc = await this.taskCollection.doc(taskId).get();
      return doc.exists;
    } catch (error) {
      console.error(error);
      return false;
    }
  }
}
