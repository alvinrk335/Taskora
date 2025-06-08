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
    final todayWorkload = task.workload.entries
        .where(
          (entry) =>
              entry.key.year == now.year &&
              entry.key.month == now.month &&
              entry.key.day == now.day,
        )
        .fold<double>(0, (sum, entry) => sum + entry.value.toNumber());

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
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade200,
                    ),
                    child: Text(
                      task.type.toString().split('.').last,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
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
                  'Workload\n${todayWorkload > 0 ? todayWorkload.toInt() : '-'} hrs',
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
