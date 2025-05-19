import 'package:taskora/model/entity/task.dart';

class TaskEditState {
  final List<Task> tasks;

  TaskEditState({required this.tasks});

TaskEditState addOrUpdateTask(Task newTask) {
  final index = tasks.indexWhere((task) => task.taskId == newTask.taskId);

  if (index == -1) {
    // Task tidak ditemukan, tambahkan baru
    final updatedTasks = List<Task>.from(tasks)..add(newTask);
    return TaskEditState(tasks: updatedTasks);
  } else {
    // Task ditemukan, replace dengan task baru
    final updatedTasks = List<Task>.from(tasks);
    updatedTasks[index] = newTask;
    return TaskEditState(tasks: updatedTasks);
  }
}

}
