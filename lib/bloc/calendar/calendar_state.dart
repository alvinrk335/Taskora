import 'package:table_calendar/table_calendar.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/entity/task.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final Schedule schedule;
  final DateTime? selectedDay;
  final CalendarFormat? calendarFormat;
  CalendarLoaded({
    required this.schedule,
    this.selectedDay,
    this.calendarFormat,
  });

  loadEvent() {
    Map<DateTime, List<Task>> events = {};
    for (var task in schedule.getTasks) {
      // Loop through each date in the workload map (interval-based)
      task.workload.forEach((dateStr, intervals) {
        // Parse dateStr (format: YYYY-MM-DD)
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          final year = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final day = int.tryParse(parts[2]);
          if (year != null && month != null && day != null) {
            final dayObj = DateTime(year, month, day);
            events.putIfAbsent(dayObj, () => []).add(task);
          }
        }
      });
    }
    return events;
  }

  CalendarLoaded copyWith({
    Schedule? schedule,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
  }) {
    return CalendarLoaded(
      schedule: schedule ?? this.schedule,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }
}

class CalendarEmpty extends CalendarState {}
