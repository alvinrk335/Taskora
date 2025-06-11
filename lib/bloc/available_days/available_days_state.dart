class AvailableDaysState {
  final List<DateTime> dates;
  final Map<String, List<Map<String, String>>> weeklyWorkIntervals;

  const AvailableDaysState({
    required this.dates,
    required this.weeklyWorkIntervals,
  });

  Map<String, List<Map<String, String>>> getAvailableIntervalsPerDate() {
    final Map<String, List<Map<String, String>>> result = {};
    for (final date in dates) {
      final weekday = _weekdayName(date.weekday);
      final intervals = weeklyWorkIntervals[weekday] ?? [];
      result[date.toIso8601String().substring(0, 10)] = intervals;
    }
    return result;
  }

  @override
  String toString() {
    final datesStr = dates
        .map((d) => d.toIso8601String().substring(0, 10))
        .join(", ");
    final intervalsStr = weeklyWorkIntervals.entries
        .map(
          (e) =>
              "${e.key}: ${e.value.map((i) => '${i['start']}-${i['end']}').join(', ')}",
        )
        .join(", ");
    return "AvailableDaysState(\n  dates: [$datesStr],\n  weeklyWorkIntervals: {$intervalsStr}\n)";
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
      weeklyWorkIntervals: weeklyWorkIntervals,
    );
  }

  AvailableDaysState removeDate(DateTime dateToRemove) {
    return AvailableDaysState(
      dates: dates.where((d) => !isSameDay(d, dateToRemove)).toList(),
      weeklyWorkIntervals: weeklyWorkIntervals,
    );
  }

  AvailableDaysState updateWorkIntervals(
    String dayName,
    List<Map<String, String>> newIntervals,
  ) {
    final updated = Map<String, List<Map<String, String>>>.from(
      weeklyWorkIntervals,
    )..[dayName] = newIntervals;
    return AvailableDaysState(dates: dates, weeklyWorkIntervals: updated);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
