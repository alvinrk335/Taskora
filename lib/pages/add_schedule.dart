import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/task_priority/task_priority_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_bloc.dart';
import 'package:taskora/widgets/add_task_body.dart';
import 'package:taskora/widgets/initial_task_list.dart';

class AddSchedule extends StatelessWidget {
  const AddSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskAddBloc()),
        BlocProvider(create: (_) => TaskTypeBloc()),
        BlocProvider(create: (_) => TaskPriorityBloc()),
      ],
      child: const AddScheduleBody(),
    );
  }
}

class AddScheduleBody extends StatefulWidget {
  const AddScheduleBody({super.key});

  @override
  State<AddScheduleBody> createState() => _AddScheduleBodyState();
}

class _AddScheduleBodyState extends State<AddScheduleBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder:
                            (ctx) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<TaskAddBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<TaskTypeBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<TaskPriorityBloc>(),
                                ),
                              ],
                              child: const AddTaskDialog(),
                            ),
                      ),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
          const Expanded(child: InitialTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.offline_bolt),
      ),
    );
  }
}
