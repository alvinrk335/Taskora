import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/entity/task.dart';

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
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor,
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
                          // Ambil workload total per hari (interval-based)
                          final selectedStr =
                              "${selectedDay.year.toString().padLeft(4, '0')}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
                          final intervals = task.workload[selectedStr] ?? [];
                          final currTaskWorkload = intervals.fold<double>(
                            0,
                            (sum, interval) =>
                                sum + (interval['workload'] ?? 0),
                          );
                          return Text(
                            "workload: ${currTaskWorkload > 0 ? currTaskWorkload.toStringAsFixed(1) : '-'} hrs",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        } else {
                          // Total workload seluruh hari
                          double total = 0;
                          task.workload.forEach((date, intervals) {
                            total += intervals.fold<double>(
                              0,
                              (sum, interval) =>
                                  sum + (interval['workload'] ?? 0),
                            );
                          });
                          return Text(
                            "total workload: ${total > 0 ? total.toStringAsFixed(1) : '-'} hrs",
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
