import 'package:taskora/model/tasktype.dart';

abstract class TaskTypeEvent {}

class TypeChanged extends TaskTypeEvent{
  final TaskType? type;
  TypeChanged({TaskType? type}) : type = type ?? TaskType.other;
}
