import 'package:taskora/model/schedule.dart';
import 'package:taskora/model/task.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final Schedule schedule;
  CalendarLoaded(this.schedule);

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
}

class CalendarEmpty extends CalendarState {}
