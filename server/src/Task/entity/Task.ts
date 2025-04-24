import Duration from "./value_object/Duration";
import Name from "./value_object/Name";
import Description from "./value_object/Description";
import taskType from "./value_object/TaskType";
import {Timestamp} from "firebase-admin/firestore";

export default class Task {
  private taskId: string;
  private taskName: Name;
  private description: Description;
  private priority: number;
  private type: taskType;
  private preferredDays: Date[];
  private deadline: Date;
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
    preferredDays,
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
        preferredDays: Date[];
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
    this.preferredDays = preferredDays;
    this.deadline = deadline;
    this.weight = weight;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.workload = workload;
    this.estimatedDuration = estimatedDuration;
  }
  static fromJSON(json: any): Task {
    const workloadMap = new Map<Date, Duration>();
    const rawWorkload = json.workload ?? {};

    for (const [dateStr, durationVal] of Object.entries(rawWorkload)) {
      const date = new Date(dateStr);
      const duration = Duration.fromNumber(typeof durationVal === "number" ? durationVal : (durationVal as any).minutes);
      workloadMap.set(date, duration);
    }

    return new Task({
      taskId: json.taskId,
      taskName: Name.fromString(json.taskName),
      description: Description.fromString(json.description),
      priority: json.priority,
      type: taskType.fromString(json.type),
      preferredDays: (json.preferredDays ?? []).map((d: string) => new Date(d)),
      deadline: new Date(json.deadline),
      weight: json.weight,
      createdAt: Timestamp.fromDate(new Date(json.createdAt)),
      updatedAt: Timestamp.fromDate(new Date(json.updatedAt)),
      workload: workloadMap,
      estimatedDuration: Duration.fromNumber(json.estimatedDuration ?? 0),
    });
  }
  toJSON() {
    const workloadObject: { [date: string]: Duration } = {};
    this.workload.forEach((value, key) => {
      workloadObject[key.toISOString()] = value;
    });

    return {
      taskId: this.taskId,
      taskName: this.taskName.toString(),
      description: this.description.toString(),
      priority: this.priority,
      type: this.type.toString(),
      preferredDays: this.preferredDays.map((date) => date.toISOString()),
      deadline: this.deadline.toISOString(),
      estimatedDuration: this.estimatedDuration?.toNumber() ?? 0,
      weight: this.weight,
      createdAt: this.createdAt.toDate(),
      updatedAt: this.updatedAt.toDate(),
      workload: workloadObject,
    };
  }

  // Getter dan Setter
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

  public getPreferredDays(): Date[] {
    return this.preferredDays;
  }

  public setPreferredDays(preferredDays: Date[]): void {
    this.preferredDays = preferredDays;
  }

  public getDeadline(): Date {
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

  // Menambahkan atau memperbarui workload untuk tanggal tertentu
  public addWorkload(date: Date, duration: Duration): void {
    this.workload.set(date, duration);
  }

  // Menghitung total durasi yang teralokasi
  public getTotalWorkload(): number {
    let total = 0;
    this.workload.forEach((duration) => {
      total += duration.toNumber();
    });
    return total;
  }
}
