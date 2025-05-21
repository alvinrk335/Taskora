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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> master
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                ),
                const SizedBox(width: 12),
                Text(
                  'Deadline: ${task.deadline?.toString().split(" ")[0] ?? 'None'}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Description:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(task.description.value, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Priority: ${task.priority}', style: const TextStyle(color: Colors.white)),
            Text('Type: ${task.type.toString().split('.').last}', style: const TextStyle(color: Colors.white)),
          ],
        ),
      )),
    );
  }
}
