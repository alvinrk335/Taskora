import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';
import 'package:taskora/widgets/task%20list/compact_task_card.dart';
import 'package:taskora/widgets/task%20list/task_card.dart';

class TaskList extends StatelessWidget {
  final bool? compact;
  final CardType cardType;
  final void Function(Task task)? onTap;
  final bool? showAll;
  final SummaryType? summaryType;
  final bool? timeline;
  const TaskList({
    super.key,
    required this.cardType,
    this.onTap,
    this.compact,
    this.summaryType,
    this.showAll,
    this.timeline,
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
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (scheduleContext, scheduleState) {
        if (scheduleState is CalendarLoaded) {
          List<Task> tasks = scheduleState.schedule.getTasks;
          sortTaskByDeadline(tasks);
          final selectedDay = scheduleState.selectedDay;
          if (timeline == true && selectedDay != null) {
            // Only show tasks for selectedDay (timeline mode)
            tasks =
                tasks.where((task) {
                  return task.workload.keys.any(
                    (date) {
                      // Parse date string to DateTime
                      final parts = date.split('-');
                      final taskDate = DateTime(
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                        int.parse(parts[2]),
                      );
                      return isSameDay(taskDate, selectedDay);
                    },
                  );
                }).toList();
            if (tasks.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Tidak ada event pada hari ini."),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    "Timeline Hari Ini",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ...tasks.map(
                  (task) => ListTile(
                    title: Text(task.taskName.toString()),
                    subtitle: Text(task.type.toString()),
                  ),
                ),
              ],
            );
          }
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
              if (selectedDay == null) {
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
              } else {
                tasks =
                    tasks.where((task) {
                      return task.workload.keys.any(//inijuga untuk timeline
                        (date) {
                          // Parse date string to DateTime
                          final parts = date.split('-');
                          final taskDate = DateTime(
                            int.parse(parts[0]),
                            int.parse(parts[1]),
                            int.parse(parts[2]),
                          );
                          return isSameDay(taskDate, selectedDay);
                        },
                      );
                    }).toList();
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
            }
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
