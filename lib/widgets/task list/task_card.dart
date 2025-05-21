<<<<<<< HEAD
=======
// ignore_for_file: deprecated_member_use

>>>>>>> master
import 'package:flutter/material.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';

class TaskCard extends StatelessWidget {
  final void Function(Task task)? onTap;
  final Task task;
  final CardType cardType;
  final SummaryType? summaryMode;
  const TaskCard({
    super.key,
    required this.task,
    required this.cardType,
    this.onTap,
    this.summaryMode,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = const Color(0xFF2D2D2D);
    final titleStyle = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF80CBC4),
    );
    final textStyle = const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14,
      color: Colors.white70,
      height: 1.4,
    );

    Widget buildEditButton() {
      return Container(
        height: 20, // Set explicit height for smaller button
        decoration: BoxDecoration(
          color: Colors.white,
<<<<<<< HEAD
          borderRadius: BorderRadius.circular(14), // Half of height for perfect circle ends
=======
          borderRadius: BorderRadius.circular(
            14,
          ), // Half of height for perfect circle ends
>>>>>>> master
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (onTap != null) {
                onTap!(task);
              }
            },
            child: Padding(
<<<<<<< HEAD
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
=======
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ), // Reduced padding
>>>>>>> master
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 14, // Smaller icon
                    color: Color(0xFF7E57C2),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'view details',
                    style: TextStyle(
                      color: Color(0xFF7E57C2),
                      fontSize: 11, // Smaller text
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (cardType == CardType.regular) {
      return SizedBox(
        width: 400,
        height: 200,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.taskName.toString(),
                            style: titleStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
<<<<<<< HEAD
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
=======
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
>>>>>>> master
                          decoration: BoxDecoration(
                            color: const Color(0xFF80CBC4).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.type.toString(),
                            style: TextStyle(
                              color: Color(0xFF80CBC4),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  buildEditButton(),
                ],
              ),
<<<<<<< HEAD
              Divider(
                color: Colors.white24,
                thickness: 1,
                height: 24,
              ),
=======
              Divider(color: Colors.white24, thickness: 1, height: 24),
>>>>>>> master
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
<<<<<<< HEAD
                          Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                          const SizedBox(width: 8),
                          Text(
                            task.deadline?.toString().split(' ')[0] ?? 'No deadline',
                            style: textStyle,
=======
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.deadline?.toString().split(' ')[0] ??
                                'No deadline',
                            style: textStyle,
                            overflow: TextOverflow.fade,
>>>>>>> master
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.flag, size: 16, color: Colors.white70),
                          const SizedBox(width: 8),
<<<<<<< HEAD
                          Text(
                            'Priority: ${task.priority}',
                            style: textStyle,
                          ),
=======
                          Text('Priority: ${task.priority}', style: textStyle),
>>>>>>> master
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (task.description.value.isNotEmpty) ...[
                        Text(
                          task.description.value,
                          style: textStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // button card
    else if (cardType == CardType.button) {
      return SizedBox(
        width: 400,
        height: 200,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (onTap != null) {
                  onTap!(task);
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.taskName.toString(),
                                style: titleStyle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
<<<<<<< HEAD
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF80CBC4).withOpacity(0.15),
=======
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF80CBC4,
                                ).withOpacity(0.15),
>>>>>>> master
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                task.type.toString(),
                                style: TextStyle(
                                  color: Color(0xFF80CBC4),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      buildEditButton(),
                    ],
                  ),
<<<<<<< HEAD
                  Divider(
                    color: Colors.white24,
                    thickness: 1,
                    height: 24,
                  ),
=======
                  Divider(color: Colors.white24, thickness: 1, height: 24),
>>>>>>> master
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
<<<<<<< HEAD
                              Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                              const SizedBox(width: 8),
                              Text(
                                task.deadline?.toString().split(' ')[0] ?? 'No deadline',
=======
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task.deadline?.toString().split(' ')[0] ??
                                    'No deadline',
>>>>>>> master
                                style: textStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.flag, size: 16, color: Colors.white70),
                              const SizedBox(width: 8),
                              Text(
                                'Priority: ${task.priority}',
                                style: textStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (task.description.value.isNotEmpty) ...[
                            Text(
                              task.description.value,
                              style: textStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    //else
    else {
      return Text("invalid card type");
    }
  }
}
