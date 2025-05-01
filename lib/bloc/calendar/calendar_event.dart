abstract class CalendarEvent {}

class LoadRequest extends CalendarEvent {
  String uid;
  LoadRequest(this.uid);
}

class DeloadRequest extends CalendarEvent {}

class ReloadRequest extends CalendarEvent {}
