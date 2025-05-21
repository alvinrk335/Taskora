import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_state.dart';
import 'package:taskora/bloc/task_priority/task_priority_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_bloc.dart';
import 'package:taskora/model/entity/initial_task.dart';
import 'package:taskora/widgets/add%20schedule/add_task_body.dart';
import 'package:taskora/widgets/task%20list/flat_task_card.dart';

class InitialTaskList extends StatelessWidget {
  const InitialTaskList({super.key});

  
  void _showEditDialog(BuildContext context, InitialTask task) {
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
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
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskAddBloc, TaskAddState>(
      builder: (context, state) {
        if (state.tasks.isEmpty) {
          return const Center(
            child: Text(
              'No tasks available',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
          );
        }

        return SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.tasks.length,
            itemBuilder: (itemContext, index) {
              final task = state.tasks[index];
              return FlatTaskCard(
                task: task,
                onTap: () => _showEditDialog(context, task),
              );
            },
          ),
        );
      },
    );
  }

}
