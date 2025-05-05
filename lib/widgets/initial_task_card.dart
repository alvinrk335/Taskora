import 'package:flutter/material.dart';
import 'package:taskora/model/initial_task.dart';

class InitialTaskCard extends StatelessWidget {
  final InitialTask task;

  const InitialTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
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
          Divider(),
          Text(
            "Deadline: ${task.deadline.toString()}\nType: ${task.type.toString()}\nDescription: ${task.description.toString()}\nPriority: ${task.priority.toString()}\n",
          ),
        ],
      ),
    );
  }
}
