import 'package:taskora/model/initial_task.dart';

abstract class TaskAddEvent {}

class TaskAdded extends TaskAddEvent {
  final InitialTask task;
  TaskAdded({required this.task});
}

class TaskRemoved extends TaskAddEvent {
  final int index;
  TaskRemoved({required this.index});
}
