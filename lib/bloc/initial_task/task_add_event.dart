import 'package:taskora/model/entity/initial_task.dart';

abstract class TaskAddEvent {}

class TaskAdded extends TaskAddEvent {
  final InitialTask task;
  TaskAdded({required this.task});
}

class TaskRemoved extends TaskAddEvent {
  final int index;
  TaskRemoved({required this.index});
}

class TaskEdited extends TaskAddEvent {
  final InitialTask task;
  TaskEdited({required this.task});
}

