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
    final todayStr =
        "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final todayIntervals = task.workload[todayStr] ?? [];
    return todayIntervals.fold<double>(
      0,
      (sum, interval) => sum + (interval['workload'] ?? 0),
    );
  }

  double get totalWorkload {
    double total = 0;
    task.workload.forEach((date, intervals) {
      total += intervals.fold<double>(
        0,
        (sum, interval) => sum + (interval['workload'] ?? 0),
      );
    });
    return total;
  }

  double get progress {
    if (totalWorkload == 0) return 1.0;
    return (todayWorkload / totalWorkload);
  }

  void markTodayDone() {
    setState(() {
      final todayStr =
          "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      task.workload.remove(todayStr);
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
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          Text('Progress: \n${(progress * 100).toInt()}%'),
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
                        ),
                      ),
                      content: const Text(
                        "Are you sure you want to mark today's workload as done?",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                      actions: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "cancel",
                                style: TextStyle(fontFamily: 'Montserrat'),
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
