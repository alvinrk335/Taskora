import 'package:table_calendar/table_calendar.dart';

abstract class CalendarEvent {}

class LoadRequest extends CalendarEvent {
  String uid;
  LoadRequest(this.uid);
}

class DeloadRequest extends CalendarEvent {}

class ReloadRequest extends CalendarEvent {}

class DaySelected extends CalendarEvent {
  final DateTime? daySelected;
  DaySelected({required this.daySelected});
}

class CalendarFormatChanged extends CalendarEvent {
  final CalendarFormat calendarFormat;
  CalendarFormatChanged({required this.calendarFormat});
}
