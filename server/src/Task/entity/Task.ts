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
  private deadline?: Date | string;
  private weight: number;
  private createdAt: Timestamp;
  private updatedAt: Timestamp;
  private workload: Map<Date, Duration>;
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
    deadline: Date;
    weight: number;
    createdAt: Timestamp;
    updatedAt: Timestamp;
    workload: Map<Date, Duration>;
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

  public static parseFirestoreTimestamp(input: any): Date {
    if (!input) return new Date();
    if (input instanceof Timestamp) return input.toDate();
    if (input._seconds && input._nanoseconds) {
      return new Date(input._seconds * 1000 + Math.floor(input._nanoseconds / 1e6));
    }
    if (typeof input === 'string' || typeof input === 'number') {
      return new Date(input);
    }
    return new Date(); // fallback
  }

  static fromJSON(json: any): Task {
    const workloadMap = new Map<Date, Duration>();
    const rawWorkload = json.workload ?? {};

    for (const [dateStr, durationVal] of Object.entries(rawWorkload)) {
      const date = new Date(dateStr);
      const duration = Duration.fromNumber(
        typeof durationVal === "number"
          ? durationVal
          : (durationVal as any).minutes
      );
      workloadMap.set(date, duration);
    }

    return new Task({
      taskId: json.taskId,
      taskName: Name.fromString(json.taskName),
      description: Description.fromString(json.description),
      priority: json.priority,
      type: taskType.fromString(json.type),
      deadline: Task.parseFirestoreTimestamp(json.deadline),
      weight: json.weight,
      createdAt: Timestamp.fromDate(Task.parseFirestoreTimestamp(json.createdAt)),
      updatedAt: Timestamp.fromDate(Task.parseFirestoreTimestamp(json.updatedAt)),
      workload: workloadMap,
      estimatedDuration: Duration.fromNumber(json.estimatedDuration ?? 0),
    });
  }

  toJSON() {
    const workloadObject: { [date: string]: Number } = {};
    this.workload.forEach((value, key) => {
      workloadObject[key.toISOString()] = value.toNumber();
    });

    return {
      taskId: this.taskId,
      taskName: this.taskName.toString(),
      description: this.description.toString(),
      priority: this.priority,
      type: this.type.toString(),
      deadline:
        this.deadline instanceof Date
          ? this.deadline.toISOString()
          : new Date(this.deadline ?? "").toISOString(),
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

  public getDeadline(): Date | string | undefined {
    return this.deadline;
  }

  public setDeadline(deadline: Date): void {
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

  public getWorkload(): Map<Date, Duration> {
    return this.workload;
  }

  public setWorkload(workload: Map<Date, Duration>): void {
    this.workload = workload;
  }

  public addWorkload(date: Date, duration: Duration): void {
    this.workload.set(date, duration);
  }

  public getTotalWorkload(): number {
    let total = 0;
    this.workload.forEach((duration) => {
      total += duration.toNumber();
    });
    return total;
  }
}
