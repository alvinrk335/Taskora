import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/task.dart';
import 'package:taskora/widgets/task_card.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  List<Task> getTasks(BuildContext context) {
    final state = context.read<CalendarBloc>().state;

    if (state is CalendarLoaded) {
      return state.schedule.getTasks;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = getTasks(context);
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (scheduleContext, scheduleState) {
        if (scheduleState is CalendarLoaded) {
          if (tasks.isNotEmpty) {
            return Wrap(
              children: [for (Task task in tasks) TaskCard(task: task)],
            );
          } else {
            return Center(child: Text("schedule is empty"));
          }
        } else if (scheduleState is CalendarLoading) {
          return SizedBox.shrink();
        }
        return Text("error no state");
      },
    );
  }
}
