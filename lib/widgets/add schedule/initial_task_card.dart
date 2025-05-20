import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/task_priority/task_priority_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_bloc.dart';
import 'package:taskora/model/entity/initial_task.dart';
import 'package:taskora/widgets/add%20schedule/add_task_body.dart';

class InitialTaskCard extends StatelessWidget {
  final InitialTask task;

  const InitialTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.black),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (_) => BlocProvider.value(
                  value: context.read<TaskAddBloc>(),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => TaskTypeBloc()),
                      BlocProvider(create: (_) => TaskPriorityBloc()),
                    ],
                    child: AddOrEditTaskDialog(initialTask: task),
                  ),
                ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                task.taskName.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Deadline: ${task.deadline?.toString() ?? 'None'}\n"
                "Type: ${task.type.toString()}\n"
                "Description: ${task.description.toString()}\n"
                "Priority: ${task.priority.toString()}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
