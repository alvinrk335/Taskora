import 'package:taskora/model/tasktype.dart';

class TaskTypeState {
  final TaskType type;

  TaskTypeState({required this.type});

  TaskTypeState copyWith({TaskType? type}) {
    return TaskTypeState(type: type ?? this.type);
  }
}
