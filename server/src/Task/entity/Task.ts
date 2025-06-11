import Duration from "./value_object/Duration";
import Name from "./value_object/Name";
import Description from "./value_object/Description";
import taskType from "./value_object/TaskType";
import { Timestamp } from "firebase-admin/firestore";

export default class Task {
  private taskId: string;
  private taskName: Name;
  private description: Description;
  private priority: number;
  private type: taskType;
  private deadline: Date | string | null;
  private weight: number;
  private createdAt: Timestamp;
  private updatedAt: Timestamp;
  private workload: Map<string, { interval: [string, string]; workload: number }[]>;
  private estimatedDuration?: Duration;

  constructor({
    taskId,
    taskName,
    description,
    priority,
    type,
    deadline,
    weight,
    createdAt,
    updatedAt,
    workload,
    estimatedDuration,
  }: {
    taskId: string;
    taskName: Name;
    description: Description;
    priority: number;
    type: taskType;
    deadline: Date | string | null;
    weight: number;
    createdAt: Timestamp;
    updatedAt: Timestamp;
    workload: Map<string, { interval: [string, string]; workload: number }[]>;
    estimatedDuration?: Duration;
  }) {
    this.taskId = taskId;
    this.taskName = taskName;
    this.description = description;
    this.priority = priority;
    this.type = type;
    this.deadline = deadline;
    this.weight = weight;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.workload = workload;
    this.estimatedDuration = estimatedDuration;
  }

  public static parseFirestoreTimestamp(input: any): Date | null {
    if (!input) return null;
    if (input instanceof Timestamp) return input.toDate();
    if (input._seconds && input._nanoseconds) {
      return new Date(input._seconds * 1000 + Math.floor(input._nanoseconds / 1e6));
    }
    if (typeof input === "string" || typeof input === "number") {
      const d = new Date(input);
      return isNaN(d.getTime()) ? null : d;
    }
    return null; // fallback
  }

  static fromJSON(json: any): Task {
    const workloadMap = new Map<string, { interval: [string, string]; workload: number }[]>();
    const rawWorkload = json.workload ?? {};
    for (const [dateStr, intervals] of Object.entries(rawWorkload)) {
      if (Array.isArray(intervals)) {
        workloadMap.set(
          dateStr,
          intervals.map((iw: any) => ({
            interval: [iw.interval[0], iw.interval[1]],
            workload: iw.workload,
          }))
        );
      }
    }
    return new Task({
      taskId: json.taskId,
      taskName: Name.fromString(json.taskName),
      description: Description.fromString(json.description),
      priority: json.priority,
      type: taskType.fromString(json.type),
      deadline: Task.parseFirestoreTimestamp(json.deadline ?? null),
      weight: json.weight,
      createdAt: Timestamp.fromDate(Task.parseFirestoreTimestamp(json.createdAt) ?? new Date()),
      updatedAt: Timestamp.fromDate(Task.parseFirestoreTimestamp(json.updatedAt) ?? new Date()),
      workload: workloadMap,
      estimatedDuration: Duration.fromMinutes(json.estimatedDuration ?? 0),
    });
  }

  toJSON() {
    const workloadObject: { [date: string]: { interval: [string, string]; workload: number }[] } = {};
    this.workload.forEach((value, key) => {
      workloadObject[key] = value;
    });

    let deadlineISO: string | null = null;
    if (this.deadline instanceof Date && !isNaN(this.deadline.getTime())) {
      deadlineISO = this.deadline.toISOString();
    } else if (typeof this.deadline === "string") {
      const parsedDate = new Date(this.deadline);
      if (!isNaN(parsedDate.getTime())) {
        deadlineISO = parsedDate.toISOString();
      }
    }

    return {
      taskId: this.taskId,
      taskName: this.taskName.toString(),
      description: this.description.toString(),
      priority: this.priority,
      type: this.type.toString(),
      deadline: deadlineISO,
      estimatedDuration: this.estimatedDuration?.toNumber() ?? 0,
      weight: this.weight,
      createdAt: this.createdAt.toDate(),
      updatedAt: this.updatedAt.toDate(),
      workload: workloadObject,
    };
  }

  // Getters & Setters
  public getTaskId(): string {
    return this.taskId;
  }

  public setTaskId(taskId: string): void {
    this.taskId = taskId;
  }

  public getTaskName(): Name {
    return this.taskName;
  }

  public setTaskName(taskName: Name): void {
    this.taskName = taskName;
  }

  public getDescription(): Description {
    return this.description;
  }

  public setDescription(description: Description): void {
    this.description = description;
  }

  public getPriority(): number {
    return this.priority;
  }

  public setPriority(priority: number): void {
    this.priority = priority;
  }

  public getType(): taskType {
    return this.type;
  }

  public setType(type: taskType): void {
    this.type = type;
  }

  public getDeadline(): Date | string | null {
    return this.deadline;
  }

  public setDeadline(deadline: Date | string | null): void {
    this.deadline = deadline;
  }

  public getEstimatedDuration(): Duration {
    return this.estimatedDuration ?? new Duration(0);
  }

  public setEstimatedDuration(estimatedDuration: Duration): void {
    this.estimatedDuration = estimatedDuration;
  }

  public getWeight(): number {
    return this.weight;
  }

  public setWeight(weight: number): void {
    this.weight = weight;
  }

  public getWorkload(): Map<string, { interval: [string, string]; workload: number }[]> {
    return this.workload;
  }

  public setWorkload(workload: Map<string, { interval: [string, string]; workload: number }[]>): void {
    this.workload = workload;
  }

  public addWorkload(date: string, intervals: { interval: [string, string]; workload: number }[]): void {
    this.workload.set(date, intervals);
  }

  public getTotalWorkload(): number {
    let total = 0;
    this.workload.forEach((intervals) => {
      for (const iw of intervals) {
        total += iw.workload;
      }
    });
    return total;
  }

  toComplianceFormat(): {
    taskId: string;
    taskName: string;
    deadline?: string;
    estimatedDuration?: number;
    workload?: { [date: string]: number };
  } {
    const rawWorkloadMap = this.getWorkload();
    const plainWorkload: { [date: string]: number } = {};

    if (rawWorkloadMap) {
      for (const [date, intervals] of rawWorkloadMap.entries()) {
        // date is now a string (YYYY-MM-DD)
        let total = 0;
        for (const iw of intervals) {
          total += iw.workload;
        }
        plainWorkload[date] = total;
      }
    }

    const deadline = this.getDeadline();

    let deadlineStr: string | undefined;
    if (deadline instanceof Date) {
      deadlineStr = deadline.toISOString().split("T")[0];
    } else if (typeof deadline === "string") {
      deadlineStr = deadline.split("T")[0];
    } else {
      deadlineStr = undefined;
    }

    return {
      taskId: this.getTaskId(),
      taskName: this.getTaskName().name,
      deadline: deadlineStr,
      estimatedDuration: this.getEstimatedDuration()
        ? this.getEstimatedDuration().getInHours()
        : undefined,
      workload: Object.keys(plainWorkload).length > 0 ? plainWorkload : undefined,
    };
  }
}
