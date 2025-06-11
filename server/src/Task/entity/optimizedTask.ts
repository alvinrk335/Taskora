import Duration from "./value_object/Duration";
import Name from "./value_object/Name";

type IntervalWorkload = { interval: [string, string], workload: number };

class optimizedTask {
  constructor(
    private taskId: string,
    private taskName: Name,
    private workload: Map<string, IntervalWorkload[]>
  ) {}

  static fromJSON(json: any): optimizedTask {
    const taskId = json.taskId;
    const taskName = Name.fromString(json.taskName);
    const workload = new Map<string, IntervalWorkload[]>();
    if (json.workload && typeof json.workload === "object") {
      for (const [dateStr, intervals] of Object.entries(json.workload)) {
        if (Array.isArray(intervals)) {
          workload.set(dateStr, intervals.map((iw: any) => ({
            interval: [iw.interval[0], iw.interval[1]],
            workload: iw.workload
          })));
        }
      }
    }
    return new optimizedTask(taskId, taskName, workload);
  }

  toJSON() {
    const workloadObject: { [date: string]: IntervalWorkload[] } = {};
    this.workload.forEach((value, key) => {
      workloadObject[key] = value;
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
  public getWorkload(): Map<string, IntervalWorkload[]> {
    return this.workload;
  }

  public setWorkload(workload: Map<string, IntervalWorkload[]>): void {
    this.workload = workload;
  }

  // Add or update workload for a specific day
  public setWorkloadForDate(date: string, intervals: IntervalWorkload[]): void {
    this.workload.set(date, intervals);
  }

  // Get total scheduled workload (sum of all intervals)
  public getTotalWorkload(): number {
    let total = 0;
    for (const intervals of this.workload.values()) {
      for (const iw of intervals) {
        total += iw.workload;
      }
    }
    return total;
  }

  // Optional: get workload on a specific date
  public getWorkloadOnDate(date: string): IntervalWorkload[] | undefined {
    return this.workload.get(date);
  }
}

export default optimizedTask;
