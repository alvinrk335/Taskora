import 'package:taskora/model/initial_task.dart';

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
}
