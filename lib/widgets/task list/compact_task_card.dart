import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/duration.dart';

class CompactTaskCard extends StatelessWidget {
  final Task task;
  const CompactTaskCard({super.key, required this.task});

  Color pickColor() {
    if (task.priority == 1) {
      return Colors.green;
    } else if (task.priority == 2) {
      return Colors.orange;
    } else if (task.priority == 3) {
      return Colors.red;
    }
    return Colors.transparent;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 20,
              decoration: BoxDecoration(
                color: pickColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.taskName.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  BlocBuilder<CalendarBloc, CalendarState>(
                    builder: (calendarContext, calendarState) {
                      if (calendarState is CalendarLoaded) {
                        final selectedDay = calendarState.selectedDay;
                        if (selectedDay != null) {
                          MapEntry<DateTime, DurationValue>? matchedEntry;
                          try {
                            matchedEntry = task.workload.entries.firstWhere(
                              (entry) => isSameDay(entry.key, selectedDay),
                            );
                          } catch (e) {
                            matchedEntry = null; // kalau ga ketemu, masuk sini
                          }

                          final currTaskWorkload = matchedEntry?.value;
                          return Text(
                            "workload: $currTaskWorkload",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        } else {
                          final currTaskWorkload = task.getTotalWorkload();
                          return Text(
                            "total workload: $currTaskWorkload",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
