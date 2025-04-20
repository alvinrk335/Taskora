import Description from "./value_object/Description";
import Name from "./value_object/Name";
import taskType from "./value_object/TaskType";

export default class initialTask{
    constructor(
        private taskId: string,
        private taskName: Name,
        private description: Description,
        private priority: number,
        private type: taskType,
        private preferredDays?: Date[],
        private deadline?: Date,
    ){}

    public toJSON() {
        return {
          taskId: this.taskId,
          taskName: this.taskName,
          deadline: this.deadline ? this.deadline.toISOString() : null,
          priority: this.priority,
          description: this.description,
          taskType: this.type
        };
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
    public getDeadline(): Date | undefined {
        return this.deadline;
    }

    public setDeadline(deadline: Date | undefined): void {
        this.deadline = deadline;
    }

    public setPreferredDays(days: Date[]): void{
        this.preferredDays = days;
    }

    public addPreferredDays(day: Date):void{
        (this.preferredDays ?? []).push(day);
    }

    public getPreferredDays(): Date[]{
        return this.preferredDays ?? [];
    }
}