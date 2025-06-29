import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskora/bloc/task_done/task_done_bloc.dart';
import 'package:taskora/bloc/task_done/task_done_state.dart';
import 'package:taskora/model/entity/task.dart';
import 'today_task_dialog.dart';

class TodayEventList extends StatelessWidget {
  final Task task;
  const TodayEventList({super.key, required this.task});

  void _openTaskDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => TodayTaskDialog(task: task));
  }

  String prioFromNumber(int prio) {
    switch (prio) {
      case 1:
        return 'low';
      case 2:
        return 'medium';
      case 3:
        return 'high';
      default:
        return 'invalid';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStr =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    // Ambil workload hari ini (interval-based)
    final todayIntervals = task.workload[todayStr] ?? [];
    final todayWorkload = todayIntervals.fold<double>(
      0,
      (sum, interval) => sum + (interval['workload'] ?? 0),
    );

    final deadlineStr =
        task.deadline != null
            ? DateFormat('dd - MM - yyyy').format(task.deadline!)
            : 'No deadline';

    return GestureDetector(
      onTap: () => _openTaskDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Name
                  Text(
                    task.taskName.toString(),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Deadline + Priority
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        deadlineStr,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.flag, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        prioFromNumber(task.priority),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.type.toString().split('.').last,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Workload + Done Icon
            Column(
              children: [
                Text(
                  'Workload\n${todayWorkload > 0 ? todayWorkload.toStringAsFixed(1) : '-'} hrs',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<TaskDoneBloc, TaskDoneState>(
                  builder: (context, state) {
                    if (state.done == true) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
