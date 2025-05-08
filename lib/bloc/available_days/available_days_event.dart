abstract class AvailableDaysEvent {}

class SetAvailableDates extends AvailableDaysEvent {
  final List<DateTime> dates;
  SetAvailableDates({required this.dates});
}

class SetWeeklyWorkHours extends AvailableDaysEvent {
  final Map<String, double> weeklyHours;
  SetWeeklyWorkHours({required this.weeklyHours});
}

class AddAvailableDate extends AvailableDaysEvent {
  final DateTime date;
  AddAvailableDate({required this.date});
}

class RemoveAvailableDate extends AvailableDaysEvent {
  final DateTime date;
  RemoveAvailableDate({required this.date});
}

class EditWeeklyWorkHour extends AvailableDaysEvent {
  final String day;
  final double hours;
  EditWeeklyWorkHour({required this.day, required this.hours});
}
