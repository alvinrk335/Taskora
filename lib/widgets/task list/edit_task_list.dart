import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_bloc.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_event.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_state.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';
import 'package:taskora/widgets/task%20list/compact_task_card.dart';
import 'package:taskora/widgets/task%20list/task_card.dart';

class EditTaskList extends StatelessWidget {
  final bool? compact;
  final CardType cardType;
  final void Function(Task task)? onTap;
  final bool? showAll;
  final SummaryType? summaryType;
  const EditTaskList({
    super.key,
    required this.cardType,
    this.onTap,
    this.compact,
    this.summaryType,
    this.showAll,
  });

  void sortTaskByDeadline(List<Task> task) {
    task.sort((a, b) {
      if (a.deadline == null && b.deadline == null) {
        return 0;
      }
      if (a.deadline == null) {
        return 1;
      }
      if (b.deadline == null) {
        return -1;
      }
      return a.deadline!.compareTo(b.deadline!);
    });
  }

  bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskListBloc, EditTaskListState>(
      builder: (editTaskListContext, editTaskListState) {
        final scheduleState = context.read<CalendarBloc>().state;
        Schedule? schedule;
        
        if (scheduleState is CalendarLoaded) {
          schedule = scheduleState.schedule;

          for (Task task in schedule.getTasks) {
            editTaskListContext.read<EditTaskListBloc>().add(
              AddToTaskList(task: task),
            );
          }
        }
        
        List<Task> tasks = editTaskListState.tasks;
        sortTaskByDeadline(tasks);
        if (tasks.isNotEmpty) {
          if (showAll != null) {
            if (showAll! == true) {
              return Wrap(
                children: [
                  for (Task task in tasks)
                    (compact ?? false)
                        ? CompactTaskCard(task: task)
                        : TaskCard(
                          task: task,
                          cardType: cardType,
                          onTap: onTap,
                          summaryMode: summaryType ?? SummaryType.full,
                        ),
                ],
              );
            }
          } else {
            return Wrap(
              children: [
                for (Task task in tasks)
                  (compact ?? false)
                      ? CompactTaskCard(task: task)
                      : TaskCard(
                        task: task,
                        cardType: cardType,
                        onTap: onTap,
                        summaryMode: summaryType ?? SummaryType.full,
                      ),
              ],
            );
          }
        } else {
          return Center(child: Text("schedule is empty"));
        }
        return Text("error no state");
      },
    );
  }
}
