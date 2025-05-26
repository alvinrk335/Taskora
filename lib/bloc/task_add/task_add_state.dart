import 'package:taskora/model/entity/initial_task.dart';

class TaskAddState {
  final List<InitialTask> tasks;
  TaskAddState({required this.tasks});

  TaskAddState addTask({InitialTask? task}) {
    final newTasks = List<InitialTask>.from(tasks);
    newTasks.add(task ?? InitialTask.empty());
    return TaskAddState(tasks: newTasks);
  }

  TaskAddState removeTask(int index) {
    final newTasks = List<InitialTask>.from(tasks);
    newTasks.removeAt(index);
    return TaskAddState(tasks: newTasks);
  }

  TaskAddState addOrUpdateTask(InitialTask newTask) {
    final index = tasks.indexWhere((task) => task.taskId == newTask.taskId);

    if (index == -1) {
      // Task tidak ditemukan, tambahkan baru
      final updatedTasks = List<InitialTask>.from(tasks)..add(newTask);
      return TaskAddState(tasks: updatedTasks);
    } else {
      // Task ditemukan, replace dengan task baru
      final updatedTasks = List<InitialTask>.from(tasks);
      updatedTasks[index] = newTask;
      return TaskAddState(tasks: updatedTasks);
    }
  }
}
