import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/task_priority/task_priority_event.dart';
import 'package:taskora/bloc/task_priority/task_priority_state.dart';

class TaskPriorityBloc extends Bloc<TaskPriorityEvent, TaskPriorityState> {
  TaskPriorityBloc() : super(TaskPriorityState(priority: 1)) {
    on<PriorityChanged>((event, emit) {
      emit(state.copyWith(priority: event.priority));
    });
  }
}
