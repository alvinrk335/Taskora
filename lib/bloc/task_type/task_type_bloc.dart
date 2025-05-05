import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_event.dart';
import 'package:taskora/bloc/task_type/task_type_state.dart';
import 'package:taskora/model/tasktype.dart';

class TaskTypeBloc extends Bloc<TaskTypeEvent, TaskTypeState> {
  TaskTypeBloc() : super(TaskTypeState(type: TaskType.other)) {
    on<TypeChanged>((event, emit) {
      emit(state.copyWith(type: event.type));
    });
  }
}
