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
      task.workload.forEach((date, duration) {
        final day = DateTime(date.year, date.month, date.day);
        events.putIfAbsent(day, () => []).add(task);
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
