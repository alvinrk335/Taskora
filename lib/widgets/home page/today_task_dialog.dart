import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/repository/task_repository.dart';

class TodayTaskDialog extends StatefulWidget {
  final Task task;
  const TodayTaskDialog({super.key, required this.task});

  @override
  State<TodayTaskDialog> createState() => _TodayTaskDialogState();
}

class _TodayTaskDialogState extends State<TodayTaskDialog> {
  late Task task;
  late DateTime today;
  final repo = TaskRepository();

  @override
  void initState() {
    super.initState();
    task = widget.task;
    today = DateTime.now();
  }

  double get todayWorkload {
    return task.workload.entries
        .where(
          (entry) =>
              entry.key.year == today.year &&
              entry.key.month == today.month &&
              entry.key.day == today.day,
        )
        .fold<double>(0, (sum, entry) => sum + entry.value.toNumber());
  }

  double get totalWorkload {
    return task.workload.values.fold<double>(
      0,
      (sum, val) => sum + val.toNumber(),
    );
  }

  double get progress {
    if (totalWorkload == 0) return 1.0;
    return (todayWorkload / totalWorkload);
  }

  void markTodayDone() {
    setState(() {
      task.workload.removeWhere(
        (date, _) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
      );
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deadlineStr =
        task.deadline != null
            ? DateFormat('dd MMM yyyy').format(task.deadline!)
            : 'No deadline';

    return AlertDialog(
      backgroundColor: const Color(0xFF2E2E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        task.taskName.toString(),
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF80CBC4),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Deadline: $deadlineStr',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[700],
            color: const Color(0xFF80CBC4),
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          Text(
            'Progress: \n${(progress * 100).toInt()}%',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              todayWorkload > 0 ? markTodayDone : null;
              showDialog(
                context: context,
                barrierDismissible: true,
                builder:
                    (_) => AlertDialog(
                      backgroundColor: const Color(0xFF2E2E2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        "Confirmation",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF80CBC4),
                        ),
                      ),
                      content: const Text(
                        "Are you sure you want to mark today's workload as done?",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      actions: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "cancel",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                markTodayDone();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder:
                                      (_) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF80CBC4),
                                        ),
                                      ),
                                );
                                try {
                                  await repo.updateTask(task);
                                } finally {
                                  Navigator.pop(context);
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF80CBC4),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "confirm",
                                style: TextStyle(fontFamily: 'Montserrat'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              );
            },

            icon: const Icon(Icons.check),
            label: const Text('Mark Today Done'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF80CBC4),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
