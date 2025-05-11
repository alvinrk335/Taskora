import Description from "./value_object/Description";
import Name from "./value_object/Name";
import taskType from "./value_object/TaskType";

export default class initialTask {
  constructor(
        private taskId: string,
        private taskName: Name,
        private description: Description,
        private priority: number,
        private type: taskType,
        private deadline?: Date | string,
  ) {}

  public toJSON() {
    return {
      taskId: this.taskId,
      taskName: this.taskName,
      deadline: this.deadline ? typeof this.deadline == "string" ? new Date(this.deadline).toISOString() : this.deadline.toISOString() :null,
      priority: this.priority,
      description: this.description,
      taskType: this.type,
    };
  }  
  // From JSON method
  public static fromJSON(json: any): initialTask {
    // Convert the properties from JSON back to class instances
    return new initialTask(
      json.taskId,
      Name.fromString(json.taskName), 
      Description.fromString(json.description),
      json.priority,
      taskType.fromString(json.taskType), 
      json.deadline ? new Date(json.deadline) : undefined
    );
  }
  
  // Getter dan Setter untuk taskId
  public getTaskId(): string {
    return this.taskId;
  }

  public setTaskId(taskId: string): void {
    this.taskId = taskId;
  }

  // Getter dan Setter untuk taskName
  public getTaskName(): Name {
    return this.taskName;
  }

  public setTaskName(taskName: Name): void {
    this.taskName = taskName;
  }

  // Getter dan Setter untuk description
  public getDescription(): Description {
    return this.description;
  }

  public setDescription(description: Description): void {
    this.description = description;
  }

  // Getter dan Setter untuk priority
  public getPriority(): number {
    return this.priority;
  }

  public setPriority(priority: number): void {
    this.priority = priority;
  }

  // Getter dan Setter untuk type
  public getType(): taskType {
    return this.type;
  }

  public setType(type: taskType): void {
    this.type = type;
  }

  // Getter dan Setter untuk deadline
  public getDeadline(): Date | string | undefined {
    return this.deadline;
  }

  public setDeadline(deadline: Date | undefined): void {
    this.deadline = deadline;
  }
    public changeDateFormat(format : "date" | "string"): void{
    if(format == "string"){
      this.deadline = this.deadline instanceof Date ? new Date(this.deadline).toISOString() : this.deadline ;
    }
    else{
      this.deadline = typeof this.deadline === "string"? new Date(this.deadline) : this.deadline;
    }
  }

  // public setPreferredDays(days: Date[]): void {
  //   this.preferredDays = days;
  // }

  // public addPreferredDays(day: Date):void {
  //   (this.preferredDays ?? []).push(day);
  // }

  // public getPreferredDays(): Date[] {
  //   return this.preferredDays ?? [];
  // }
}
