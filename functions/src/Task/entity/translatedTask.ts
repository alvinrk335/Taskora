import Duration from "./value_object/Duration";
import Name from "./value_object/Name";

export default class TranslatedTask{
    constructor(
        private taskId: string,
        private taskName: Name,
        private estimatedDuration: Duration,
        private weight: number,
        private deadline: Date,
        private preferredDays?: Date[]
    ){}

    toJSON() {
        return {
          taskId: this.taskId,
          estimatedDuration: this.estimatedDuration,
          weight: this.weight,
          deadline: this.deadline.toISOString(),
          preferredDays: (this.preferredDays ?? []).map(date => date.toISOString())
        };
      }
        // Getter and Setter for taskId
        public getTaskId(): string {
            return this.taskId;
        }
    
        public setTaskId(taskId: string): void {
            this.taskId = taskId;
        }
    
        // Getter and Setter for estimatedDuration
        public getEstimatedDuration(): Duration {
            return this.estimatedDuration;
        }
    
        public setEstimatedDuration(estimatedDuration: Duration): void {
            this.estimatedDuration = estimatedDuration;
        }
    
        // Getter and Setter for weight
        public getWeight(): number {
            return this.weight;
        }
    
        public setWeight(weight: number): void {
            this.weight = weight;
        }
    
        // Getter and Setter for deadline
        public getDeadline(): Date {
            return this.deadline;
        }
    
        public setDeadline(deadline: Date): void {
            this.deadline = deadline;
        }

        // Getter and Setter for preferredDays
        public getPreferredDays(): Date[] {
            return this.preferredDays ?? [];
        }

        public setPreferredDays(preferredDays: Date[]): void {
            this.preferredDays = preferredDays;
        }

        public getName(): Name{
            return this.taskName;
        }

        public setName(name: Name): void{
            this.taskName = name;
        }
}