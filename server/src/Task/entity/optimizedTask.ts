import Duration from "./value_object/Duration";
import Name from "./value_object/Name";

class optimizedTask {
  constructor(
        private taskId: string,
        private taskName: Name,
        private workload: Map<Date, Duration>
  ) {}
  static fromJSON(json: any): optimizedTask {
    const taskId = json.taskId;
    const taskName = Name.fromString(json.taskName);

    const workload = new Map<Date, Duration>();
    for (const [dateStr, durationRaw] of Object.entries(json.workload as Record<string, number | { minutes: number }>)) {
      const date = new Date(dateStr);
      const duration = typeof durationRaw === "number" ?
        Duration.fromNumber(durationRaw) :
        Duration.fromNumber(durationRaw.minutes); // jika disimpan sebagai objek
      workload.set(date, duration);
    }

    return new optimizedTask(taskId, taskName, workload);
  }
  toJSON() {
    const workloadObject: { [date: string]: Duration } = {};
    this.workload.forEach((value, key) => {
      workloadObject[key.toISOString()] = value;
    });

    return {
      taskId: this.taskId,
      taskName: this.taskName,
      workload: workloadObject,
    };
  }
  // Getter and Setter for taskId
  public getTaskId(): string {
    return this.taskId;
  }

  public setTaskId(taskId: string): void {
    this.taskId = taskId;
  }

  // Getter and Setter for taskName
  public getTaskName(): Name {
    return this.taskName;
  }

  public setTaskName(taskName: Name): void {
    this.taskName = taskName;
  }

  // Getter and Setter for workload
  public getWorkload(): Map<Date, Duration> {
    return this.workload;
  }

  public setWorkload(workload: Map<Date, Duration>): void {
    this.workload = workload;
  }

  // Add or update workload for a specific day
  public setWorkloadForDate(date: Date, duration: Duration): void {
    this.workload.set(date, duration);
  }

  // Get total scheduled workload
  public getTotalWorkload(): number {
    let total = 0;
    for (const value of this.workload.values()) {
      total += value.toNumber();
    }
    return total;
  }

  // Optional: get workload on a specific date
  public getWorkloadOnDate(date: Date): Duration | undefined {
    return this.workload.get(date);
  }
}

export default optimizedTask;
