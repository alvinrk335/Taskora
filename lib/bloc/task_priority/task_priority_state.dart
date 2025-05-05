class TaskPriorityState {
  final int priority;

  TaskPriorityState({required this.priority});

    TaskPriorityState copyWith({int? priority}) {
    return TaskPriorityState(priority: priority ?? this.priority);
  }
}
