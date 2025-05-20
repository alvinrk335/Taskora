import 'dart:developer';

import 'package:taskora/model/entity/task.dart';

class EditTaskListState {
  final List<Task> tasks;
  EditTaskListState({required this.tasks});

  EditTaskListState addOrUpdateTask(Task newTask) {
    final index = tasks.indexWhere((task) => task.taskId == newTask.taskId);

    if (index == -1) {
      // Task tidak ditemukan, tambahkan baru
      final updatedTasks = List<Task>.from(tasks)..add(newTask);
      return EditTaskListState(tasks: updatedTasks);
    } else {
      // Task ditemukan, replace dengan task baru
      final updatedTasks = List<Task>.from(tasks);
      updatedTasks[index] = newTask;
      return EditTaskListState(tasks: updatedTasks);
    }
  }

  EditTaskListState removeTask(String newTaskId) {
    final index = tasks.indexWhere((task) => task.taskId == newTaskId);
    if (index == -1) {
      log("[EDIT TASK LIST STATE] task not found to remove");
      return EditTaskListState(tasks: tasks);
    } else {
      final updatedTasks = List<Task>.from(tasks);
      updatedTasks.removeAt(index);
      return EditTaskListState(tasks: updatedTasks);
    }
  }
}
