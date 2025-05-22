import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskora/model/entity/task.dart';

class AllEventList extends StatelessWidget {
  final Task task;

  const AllEventList({super.key, required this.task});

    String prioFromNumber(int prio) {
    if (prio == 1) {
      return "low";
    } else if (prio == 2) {
      return "medium";
    } else if (prio == 3) {
      return "high";
    }
    return "invalid priority";
  }

  Widget buildEventCard(Task task) {
    final deadlineStr =
        task.deadline != null
            ? DateFormat('dd - MM - yyyy').format(task.deadline!)
            : 'No deadline';
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.taskName.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF80CBC4),
                  ),
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(width: 12),
                Text(
                  'Deadline:  $deadlineStr',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Description:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              task.description.value,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Priority: ${prioFromNumber(task.priority)}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Type: ${task.type.toString().split('.').last}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildEventCard(task);
  }
}
