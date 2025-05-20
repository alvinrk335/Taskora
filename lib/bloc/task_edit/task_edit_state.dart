import 'dart:developer';
import 'package:taskora/model/entity/task.dart';

class TaskEditState {
  final List<Task> tasks;
  final logHelper = "[TASK EDIT STATE]";
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

  TaskEditState removeTask(String newTaskId) {
    final index = tasks.indexWhere((task) => task.taskId == newTaskId);
    if (index == -1) {
      log("$logHelper task not found to remove");
      return TaskEditState(tasks: tasks);
    } else {
      final updatedTasks = List<Task>.from(tasks);
      updatedTasks.removeAt(index);
      return TaskEditState(tasks: updatedTasks);
    }
  }
}
