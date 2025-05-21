import 'package:flutter/material.dart';

class FlatTaskCard extends StatelessWidget {
  final dynamic task; // Can be Task or InitialTask
  final VoidCallback? onTap;

<<<<<<< HEAD
  const FlatTaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deadline = task.deadline != null
        ? "${task.deadline!.day} - ${task.deadline!.month} - ${task.deadline!.year}"
        : 'None';
=======
  const FlatTaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    final deadline =
        task.deadline != null
            ? "${task.deadline!.day} - ${task.deadline!.month} - ${task.deadline!.year}"
            : 'None';
>>>>>>> master

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF424242), // Changed to a lighter gray color
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
<<<<<<< HEAD
                      color: Color(0xFF80CBC4), // Changed back to teal for better contrast
=======
                      color: Color(
                        0xFF80CBC4,
                      ), // Changed back to teal for better contrast
>>>>>>> master
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
<<<<<<< HEAD
                Icon(Icons.calendar_today, size: 16, color: Colors.white), // Changed to pure white
                const SizedBox(width: 4),
                Text(
                  deadline,
                  style: const TextStyle( // Made color constant
=======
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.white,
                ), // Changed to pure white
                const SizedBox(width: 4),
                Text(
                  deadline,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    // Made color constant
>>>>>>> master
                    fontFamily: 'Montserrat',
                    color: Colors.white, // Changed to pure white
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
<<<<<<< HEAD
                Icon(Icons.flag, size: 16, color: Colors.white), // Changed to pure white
                const SizedBox(width: 4),
                Text(
                  task.priority.toString(),
                  style: const TextStyle( // Made color constant
=======
                Icon(
                  Icons.flag,
                  size: 16,
                  color: Colors.white,
                ), // Changed to pure white
                const SizedBox(width: 4),
                Text(
                  task.priority.toString(),
                  style: const TextStyle(
                    // Made color constant
>>>>>>> master
                    fontFamily: 'Montserrat',
                    color: Colors.white, // Changed to pure white
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (task.description?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                task.description.toString(),
<<<<<<< HEAD
                style: const TextStyle( // Made color constant
=======

                style: const TextStyle(
                  // Made color constant
>>>>>>> master
                  color: Colors.white, // Changed to pure white
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
<<<<<<< HEAD
                color: const Color(0xFF80CBC4), // Using teal color for tag background
=======
                color: const Color(
                  0xFF80CBC4,
                ), // Using teal color for tag background
>>>>>>> master
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                task.type.toString(),
                style: const TextStyle(
<<<<<<< HEAD
                  color: Colors.black, // Changed to black for contrast with teal background
=======
                  color:
                      Colors
                          .black, // Changed to black for contrast with teal background
>>>>>>> master
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
<<<<<<< HEAD
}
=======
}
>>>>>>> master
