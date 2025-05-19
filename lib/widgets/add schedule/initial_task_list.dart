import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_state.dart';
import 'package:taskora/model/entity/initial_task.dart';
import 'package:taskora/widgets/add%20schedule/initial_task_card.dart';

class InitialTaskList extends StatelessWidget {
  const InitialTaskList({super.key});

  List<InitialTask> getTasks(BuildContext context) {
    return context.read<TaskAddBloc>().state.tasks;
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TaskAddBloc, TaskAddState>(
      builder: (taskAddContext, taskAddState) {
        List<InitialTask> tasks = getTasks(taskAddContext);
        if (tasks.isNotEmpty) {
          return Wrap(
            children: [
              for (InitialTask task in tasks) InitialTaskCard(task: task),
            ],
          );
        } else {
          return Center(child: Text("schedule is empty"));
        }
      },
    );
  }
}
