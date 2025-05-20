import 'package:taskora/model/entity/schedule.dart';

abstract class TaskPreviewEvent {}

class AddTaskToPreview extends TaskPreviewEvent {
  final Schedule schedule;
  AddTaskToPreview({required this.schedule});
}
