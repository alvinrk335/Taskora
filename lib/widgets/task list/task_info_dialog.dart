import 'package:flutter/material.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/summary_type.dart';

class TaskInfoDialog extends StatelessWidget {
  final Task task;
  final SummaryType summaryType;
  const TaskInfoDialog({
    super.key,
    required this.task,
    required this.summaryType,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        task.taskName.toString(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            summaryType == SummaryType.compact
                ? task.toShortSummaryStringS()
                : task.toSummaryString(),
        
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("back"),
        ),
      ],
    );
  }
}
