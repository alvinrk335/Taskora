import 'package:taskora/model/entity/task.dart';

abstract class EditTaskListEvent {}

class RemoveFromTaskList extends EditTaskListEvent {
  final String taskId;
  RemoveFromTaskList({required this.taskId});
}

class AddToTaskList extends EditTaskListEvent {
  final Task task;
  AddToTaskList({required this.task});
}
