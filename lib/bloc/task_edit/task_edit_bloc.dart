import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/task_edit/task_edit_event.dart';
import 'package:taskora/bloc/task_edit/task_edit_state.dart';

class TaskEditBloc extends Bloc<TaskEditEvent, TaskEditState> {
  TaskEditBloc() : super(TaskEditState(tasks: [])) {
    on<NewTaskAdded>((event, emit) {
      final updatedState = state.addOrUpdateTask(event.task);
      emit(updatedState);
    });

    on<RemoveTaskRequest>((event, emit) {
      final updatedState = state.removeTask(event.taskId);
      emit(updatedState);
    });
  }
}
