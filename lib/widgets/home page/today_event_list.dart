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
      child: Row(
        children: [
          Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.taskName.toString(),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF80CBC4),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Deadline: $deadlineStr',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'workload: ${todayWorkload > 0 ? todayWorkload.toInt() : '-'} hrs',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<TaskDoneBloc, TaskDoneState>(
            builder: (taskDoneContext, taskDoneState) {
              if (taskDoneState.done == true) {
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
