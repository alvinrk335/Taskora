type TimeInterval = { start: string; end: string };
type WeeklyWorkIntervals = {
  [day: string]: TimeInterval[]; // Contoh: { "Monday": [{start: "08:00", end: "12:00"}], ... }
};

export class WorkHours {
  weeklyWorkIntervals: WeeklyWorkIntervals;

  constructor(weeklyWorkIntervals: WeeklyWorkIntervals) {
    this.weeklyWorkIntervals = weeklyWorkIntervals;
  }

  static fromJson(json: any): WorkHours {
    const parsed: WeeklyWorkIntervals = {};
    for (const key in json) {
      parsed[key] = (json[key] as any[]).map(
        (interval) => ({
          start: interval.start,
          end: interval.end,
        })
      );
    }
    return new WorkHours(parsed);
  }

  toJson(): WeeklyWorkIntervals {
    return { ...this.weeklyWorkIntervals };
  }

  update(dayName: string, newIntervals: TimeInterval[]): WorkHours {
    return new WorkHours({
      ...this.weeklyWorkIntervals,
      [dayName]: newIntervals,
    });
  }

  getIntervals(dayName: string): TimeInterval[] {
    return this.weeklyWorkIntervals[dayName] ?? [];
  }

  toString(): string {
    return Object.entries(this.weeklyWorkIntervals)
      .map(([day, intervals]) =>
        `${day}: ${intervals.map(i => `${i.start}-${i.end}`).join(', ')}`
      )
      .join('; ');
  }

  static empty(): WorkHours {
    return new WorkHours({
      Monday: [],
      Tuesday: [],
      Wednesday: [],
      Thursday: [],
      Friday: [],
      Saturday: [],
      Sunday: [],
    });
  }
}
