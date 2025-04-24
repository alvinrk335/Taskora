import {Timestamp} from "firebase-admin/firestore";
import Task from "../../Task/entity/Task";

class Schedule {
  private scheduleId: string;
  private tasks: Task[];
  private scheduleStart: Timestamp;
  private scheduleEnd: Timestamp;
  constructor({
    scheduleId,
    tasks,
    scheduleStart,
    scheduleEnd,
  }: {
        scheduleId: string;
        tasks: Task[];
        scheduleStart: Timestamp;
        scheduleEnd: Timestamp;
    }) {
    this.scheduleId = scheduleId;
    this.tasks = tasks;
    this.scheduleStart = scheduleStart;
    this.scheduleEnd = scheduleEnd;
  }

  // Getter dan Setter untuk scheduleId
  public getScheduleId(): string {
    return this.scheduleId;
  }

  public setScheduleId(scheduleId: string): void {
    this.scheduleId = scheduleId;
  }

  // Getter dan Setter untuk tasks
  public getTasks(): Task[] {
    return this.tasks;
  }

  public setTasks(tasks: Task[]): void {
    this.tasks = tasks;
  }

  // Getter dan Setter untuk scheduleStart
  public getScheduleStart(): Timestamp {
    return this.scheduleStart;
  }

  public setScheduleStart(scheduleStart: Timestamp): void {
    this.scheduleStart = scheduleStart;
  }

  // Getter dan Setter untuk scheduleEnd
  public getScheduleEnd(): Timestamp {
    return this.scheduleEnd;
  }

  public setScheduleEnd(scheduleEnd: Timestamp): void {
    this.scheduleEnd = scheduleEnd;
  }

  // Method untuk mengubah menjadi JSON
  public toJSON() {
    return {
      scheduleId: this.scheduleId,
      tasks: this.tasks.map((task) => task.toJSON()), // Mengubah task menjadi JSON
      scheduleStart: this.scheduleStart.toDate().toISOString(), // Mengubah Timestamp menjadi ISO string
      scheduleEnd: this.scheduleEnd.toDate().toISOString(), // Mengubah Timestamp menjadi ISO string
    };
  }

  // Static method untuk membuat objek Schedule dari JSON
  public static fromJSON(data: any): Schedule {
    const scheduleId = data.scheduleId;
    const tasks = data.tasks.map((taskData: any) => Task.fromJSON(taskData)); // Mengonversi setiap task ke objek Task
    const scheduleStart = Timestamp.fromDate(new Date(data.scheduleStart)); // Mengubah ISO string menjadi Timestamp
    const scheduleEnd = Timestamp.fromDate(new Date(data.scheduleEnd)); // Mengubah ISO string menjadi Timestamp

    return new Schedule({scheduleId: scheduleId, tasks: tasks, scheduleStart: scheduleStart, scheduleEnd: scheduleEnd});
  }
}

export default Schedule;
