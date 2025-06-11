import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/entity/task.dart';

class DailyTimeline extends StatelessWidget {
  /// A widget that represents a daily timeline;
  const DailyTimeline({super.key});

  List<Task> getEventsForDay(Schedule? schedule, DateTime date) {
    if (schedule == null) return [];
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final events =
        schedule.getTasks.where((task) {
          return task.workload.containsKey(formattedDate);
        }).toList();
    return events;
  }

  List<Task> getTasksForHour(List<Task> tasks, int hour, DateTime date) {
    final matchingTasks = <Task>[];

    for (final task in tasks) {
      final intervals = task.workload[DateFormat('yyyy-MM-dd').format(date)];
      if (intervals != null) {
        for (final interval in intervals) {
          final start = DateTime.parse(interval['start']);
          final end = DateTime.parse(interval['end']);
          if (start.hour <= hour && end.hour > hour) {
            matchingTasks.add(task);
            break; // Cukup satu interval per task per jam
          }
        }
      }
    }

    return matchingTasks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (calendarContext, calendarState) {
        DateTime date = DateTime.now();
        Schedule? schedule;
        List<Task> events = [];
        if (calendarState is CalendarLoaded) {
          date = calendarState.selectedDay!;
          schedule = calendarState.schedule;
          events = getEventsForDay(schedule, date);
        }
        return Column(
          children: [
            Text(date.toIso8601String(), style: theme.textTheme.displayLarge),
            //event timeline
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 24,
                itemBuilder: (context, hour) {
                  final tasksThisHour = getTasksForHour(events, hour, date);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${hour.toString().padLeft(2, '0')}:00',
                          style: theme.textTheme.titleLarge,
                        ),
                        if (tasksThisHour.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  tasksThisHour.map((task) {
                                    final intervals =
                                        task.workload[DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(date)]!;
                                    final interval = intervals.firstWhere((i) {
                                      final start = DateTime.parse(i['start']);
                                      final end = DateTime.parse(i['end']);
                                      return start.hour <= hour &&
                                          end.hour > hour;
                                    });

                                    return Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.taskName.toString(),
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                          Text(
                                            '${interval['start'].substring(11, 16)} - ${interval['end'].substring(11, 16)}',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
