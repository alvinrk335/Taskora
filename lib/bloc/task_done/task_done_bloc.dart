import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/task_done/task_done_event.dart';
import 'package:taskora/bloc/task_done/task_done_state.dart';

class TaskDoneBloc extends Bloc<TaskDoneEvent, TaskDoneState> {
  TaskDoneBloc() : super(TaskDoneState(done: false)) {
    on<TaskDone>((event, emit) {
      emit(TaskDoneState(done: true));
    });

    on<TaskNotDone>((event, emit) => emit(TaskDoneState(done: false)));
  }
}
