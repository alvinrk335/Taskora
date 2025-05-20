type WeeklyWorkHours = {
  [day: string]: number; // Contoh: { "Monday": 4, "Tuesday": 5 }
};

export class WorkHours {
  weeklyWorkHours: WeeklyWorkHours;

  constructor(weeklyWorkHours: WeeklyWorkHours) {
    this.weeklyWorkHours = weeklyWorkHours;
  }

  static fromJson(json: any): WorkHours {
    const parsed: WeeklyWorkHours = {};
    for (const key in json) {
      parsed[key] = Number(json[key]); // pastikan value berupa number
    }
    return new WorkHours(parsed);
  }

  toJson(): WeeklyWorkHours {
    return { ...this.weeklyWorkHours };
  }

  update(dayName: string, newHours: number): WorkHours {
    return new WorkHours({
      ...this.weeklyWorkHours,
      [dayName]: newHours,
    });
  }

  getHours(dayName: string): number {
    return this.weeklyWorkHours[dayName] ?? 0;
  }

  toString(): string {
    return Object.entries(this.weeklyWorkHours)
      .map(([day, hours]) => `${day}: ${hours}h`)
      .join(', ');
  }

  static empty(): WorkHours {
    return new WorkHours({
      Monday: 0,
      Tuesday: 0,
      Wednesday: 0,
      Thursday: 0,
      Friday: 0,
      Saturday: 0,
      Sunday: 0,
    });
  }
}
