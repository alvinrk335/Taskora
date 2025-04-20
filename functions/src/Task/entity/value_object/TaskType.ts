class taskType {
    private value: string;
  
    private constructor(value: string) {
      this.value = value;
    }
  
    static readonly WEEKLY = new taskType("weekly");
    static readonly DAILY = new taskType("daily");
    static readonly PROJECT = new taskType("project");
    static readonly WORK = new taskType("work");
    static readonly OTHER = new taskType("other");
  
    static fromString(value: string): taskType {
      switch (value.toLowerCase()) {
        case "weekly":
          return taskType.WEEKLY;
        case "daily":
          return taskType.DAILY;
        case "project":
          return taskType.PROJECT;
        case "work":
          return taskType.WORK;
        case "other":
          return taskType.OTHER;
        default:
          throw new Error(`Invalid taskType: ${value}`);
      }
    }
  
    public toString(): string {
      return this.value;
    }
  
    public equals(other: taskType): boolean {
      return this.value === other.value;
    }
  }
  
  export default taskType;
  