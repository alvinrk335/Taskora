// import 'package:taskora/model/entity/initial_task.dart';
import 'package:taskora/model/entity/task.dart';

abstract class TaskEditEvent {}

class NewTaskAdded extends TaskEditEvent {
  final Task task;
  NewTaskAdded({required this.task});
}

class RemoveTaskRequest extends TaskEditEvent {
  final String taskId;
  RemoveTaskRequest({required this.taskId});
}
