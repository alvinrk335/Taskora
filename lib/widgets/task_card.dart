import 'package:flutter/material.dart';
import 'package:taskora/model/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.black),
        ),
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(task.taskName.toString()),
            ),
            Text(task.toSummaryString(), style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
