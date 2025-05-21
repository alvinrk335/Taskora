import { Timestamp } from "firebase-admin/firestore";
import Task from "../../Task/entity/Task";

class Schedule {
  private scheduleId: string;
  private tasks: Task[];
  private scheduleStart?: Timestamp;
  private scheduleEnd?: Timestamp;

  constructor({
    scheduleId,
    tasks,
    scheduleStart = Timestamp.now(), // Default ke timestamp sekarang jika tidak ada
    scheduleEnd = Timestamp.now(), // Default ke timestamp sekarang jika tidak ada
  }: {
    scheduleId: string;
    tasks: Task[];
    scheduleStart?: Timestamp;
    scheduleEnd?: Timestamp;
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
  public getScheduleStart(): Timestamp | undefined {
    return this.scheduleStart;
  }

  public setScheduleStart(scheduleStart: Timestamp): void {
    this.scheduleStart = scheduleStart;
  }

  // Getter dan Setter untuk scheduleEnd
  public getScheduleEnd(): Timestamp | undefined {
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
      scheduleStart: this.scheduleStart?.toDate().toISOString(), // Optional chaining untuk handle undefined
      scheduleEnd: this.scheduleEnd?.toDate().toISOString(), // Optional chaining untuk handle undefined
    };
  }
  

  // Static method untuk membuat objek Schedule dari JSON
  public static fromJSON(data: any): Schedule {
    const scheduleId = data.scheduleId;
    const tasks = data.tasks ? data.tasks.map((taskData: any) => Task.fromJSON(taskData)) : [];
    const scheduleStart = data.scheduleStart ? Timestamp.fromDate(new Date(data.scheduleStart)) : Timestamp.now();
    const scheduleEnd = data.scheduleEnd ? Timestamp.fromDate(new Date(data.scheduleEnd)) : Timestamp.now();

    return new Schedule({
      scheduleId,
      tasks,
      scheduleStart,
      scheduleEnd,
    });
  }
}

export default Schedule;
