abstract class TaskPriorityEvent {}

class PriorityChanged extends TaskPriorityEvent {
  final int priority;
  PriorityChanged({required this.priority});
}
