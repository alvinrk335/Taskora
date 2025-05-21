class AvailableDaysState {
  final List<DateTime>
  dates; // tanggal yang dipilih user, misalnya hasil kalender
  final Map<String, double> weeklyWorkHours; // Senin - Minggu

  const AvailableDaysState({
    required this.dates,
<<<<<<< HEAD
    required this.weeklyWorkHours,
  });
=======
    Map<String, double>? weeklyWorkHours,
  }) : weeklyWorkHours = weeklyWorkHours ?? const {
    'Monday': 8,
    'Tuesday': 8,
    'Wednesday': 8,
    'Thursday': 8,
    'Friday': 8,
    'Saturday': 8,
    'Sunday': 8,
  };
>>>>>>> master

  Map<String, double> getAvailableTimePerDate() {
    final Map<String, double> result = {};
    for (final date in dates) {
      final weekday = _weekdayName(date.weekday); // Senin, Selasa, dst
      final hours = weeklyWorkHours[weekday] ?? 0;
      result[date.toIso8601String().substring(0, 10)] = hours;
    }
    return result;
  }

  @override
  String toString() {
    final datesStr = dates
        .map((d) => d.toIso8601String().substring(0, 10))
        .join(", ");
    final workHoursStr = weeklyWorkHours.entries
        .map((e) => "${e.key}: ${e.value}h")
        .join(", ");
    return "AvailableDaysState(\n  dates: [$datesStr],\n  weeklyWorkHours: {$workHoursStr}\n)";
  }

  static String _weekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  AvailableDaysState addDate(DateTime newDate) {
    return AvailableDaysState(
      dates: [...dates, newDate],
      weeklyWorkHours: weeklyWorkHours,
    );
  }

  AvailableDaysState removeDate(DateTime dateToRemove) {
    return AvailableDaysState(
      dates: dates.where((d) => !isSameDay(d, dateToRemove)).toList(),
      weeklyWorkHours: weeklyWorkHours,
    );
  }

  AvailableDaysState updateWorkHours(String dayName, double newHours) {
    final updatedHours = Map<String, double>.from(weeklyWorkHours)
      ..[dayName] = newHours;
    return AvailableDaysState(dates: dates, weeklyWorkHours: updatedHours);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
