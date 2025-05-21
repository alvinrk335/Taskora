import 'package:taskora/model/value%20object/tasktype.dart';

class TaskTypeState {
  final TaskType type;

  TaskTypeState({required this.type});

  TaskTypeState copyWith({TaskType? type}) {
    return TaskTypeState(type: type ?? this.type);
  }
}
