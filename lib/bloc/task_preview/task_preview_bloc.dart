import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/task_preview/task_preview_event.dart';
import 'package:taskora/bloc/task_preview/task_preview_state.dart';
import 'package:taskora/model/entity/schedule.dart';

class TaskPreviewBloc extends Bloc<TaskPreviewEvent, TaskPreviewState> {
  TaskPreviewBloc() : super(TaskPreviewState(schedule: Schedule.empty())) {
    on<AddTaskToPreview>((event, emit) {
      emit(state.addTaskPreview(event.schedule));
    });
  }
}
