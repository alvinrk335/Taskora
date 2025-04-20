export default class Duration {
    private readonly minutes: number;
  
    constructor(minutes: number) {
      if (!Number.isInteger(minutes) || minutes < 0) {
        throw new Error('Duration must be a non-negative integer.');
      }
      this.minutes = minutes;
    }
    public static fromNumber(num: number): Duration{
      return new Duration(num);
    }

    // Static factory method untuk fleksibilitas
    public static fromHours(hours: number): Duration {
      return new Duration(hours * 60);
    }
  
    public static fromMinutes(minutes: number): Duration {
      return new Duration(minutes);
    }
  
    // Getter
    public getInMinutes(): number {
      return this.minutes;
    }
  
    public getInHours(): number {
      return this.minutes / 60;
    }
  
    // Format ke string: "1h 30m"
    public toFormattedString(): string {
      const hours = Math.floor(this.minutes / 60);
      const mins = this.minutes % 60;
      if (hours > 0 && mins > 0) return `${hours}h ${mins}m`;
      if (hours > 0) return `${hours}h`;
      return `${mins}m`;
    }
  
    // Equals check
    public equals(other: Duration): boolean {
      return this.minutes === other.minutes;
    }

    public toNumber(): number{
        return this.minutes as number;
    }
  }