import 'package:taskora/model/entity/schedule.dart';

class TaskPreviewState {
  final Schedule schedule;
  TaskPreviewState({required this.schedule});

  TaskPreviewState addTaskPreview(Schedule newSchedule) {
    final currentTasks = Map.fromEntries(
      schedule.tasks.map((t) => MapEntry(t.taskId, t)),
    );
    final newTasks = Map.fromEntries(
      newSchedule.tasks.map((t) => MapEntry(t.taskId, t)),
    );

    // Gabungkan dan update task yang berubah
    for (final entry in newTasks.entries) {
      final existingTask = currentTasks[entry.key];
      if (existingTask == null || existingTask != entry.value) {
        currentTasks[entry.key] = entry.value;
      }
    }

    return TaskPreviewState(
      schedule: Schedule(
        scheduleId: newSchedule.scheduleId,
        tasks: currentTasks.values.toList(),
      ),
    );
  }
}
