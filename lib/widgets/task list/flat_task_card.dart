import 'package:flutter/material.dart';

class FlatTaskCard extends StatelessWidget {
  final dynamic task; // Can be Task or InitialTask
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FlatTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final deadline =
        task.deadline != null
            ? "${task.deadline!.day} - ${task.deadline!.month} - ${task.deadline!.year}"
            : 'None';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
// Changed to a lighter gray color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.taskName.toString(),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      // Changed back to teal for better contrast
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onDelete ?? () {},
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Delete Task',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,

                ), // Changed to pure white
                const SizedBox(width: 4),
                Text(
                  deadline,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    // Made color constant
                    fontFamily: 'Montserrat',
 // Changed to pure white
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.flag,
                  size: 16,
                  // color: Colors.white,
                ), // Changed to pure white
                const SizedBox(width: 4),
                Text(
                  task.priority.toString(),
                  style: const TextStyle(
                    // Made color constant
                    fontFamily: 'Montserrat',
                    // color: Colors.white, // Changed to pure white
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (task.description?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                task.description.toString(),

                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                task.type.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
