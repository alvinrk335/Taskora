import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_event.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_state.dart';

class EditTaskListBloc extends Bloc<EditTaskListEvent, EditTaskListState> {
  EditTaskListBloc() : super(EditTaskListState(tasks: [])) {
    on<RemoveFromTaskList>((event, emit) {
      final updatedState = state.removeTask(event.taskId);
      emit(updatedState);
    });

    on<AddToTaskList>((event, emit) {
      final updatedState = state.addOrUpdateTask(event.task);
      emit(updatedState);
    });
  }
}
