import 'package:flutter/material.dart';
import 'package:taskora/model/task.dart';

class TaskCard extends StatelessWidget {
  // final Task task;
  const TaskCard({super.key});

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
            Align(alignment: Alignment.topCenter, child: Text("data")),
          ],
        ),
      ),
    );
  }
}
