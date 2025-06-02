import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/task_add/task_add_event.dart';
import 'package:taskora/bloc/task_add/task_add_state.dart';

class TaskAddBloc extends Bloc<TaskAddEvent, TaskAddState> {
  TaskAddBloc() : super(TaskAddState(tasks: [])) {
    on<TaskAdded>((event, emit) {
      emit(state.addOrUpdateTask(event.task));
    });

    on<TaskRemoved>((event, emit) {
      emit(state.removeTask(event.index));
    });

    on<TaskEdited>((event, emit) {
      emit(state.addOrUpdateTask(event.task));
    });
  }
}
