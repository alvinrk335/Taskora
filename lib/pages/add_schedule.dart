import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_state.dart';
import 'package:taskora/bloc/task_priority/task_priority_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_bloc.dart';
import 'package:taskora/model/initial_task.dart';
import 'package:taskora/model/schedule.dart';
import 'package:taskora/model/task.dart';
import 'package:taskora/pages/calendar_page.dart';
import 'package:taskora/repository/schedule_repository.dart';
import 'package:taskora/repository/task_repository.dart';
import 'package:taskora/services/optimizer.dart';
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
  final scheduleRepo = ScheduleRepository();
  final taskRepo = TaskRepository();

  Future<Schedule> optimizeTask(BuildContext context) async {
    final List<InitialTask> tasks = context.read<TaskAddBloc>().state.tasks;
    final Map<String, double> workingHours =
        context.read<AvailableDaysBloc>().state.weeklyWorkHours;
    final List<DateTime> excludedDates =
        context.read<AvailableDaysBloc>().state.dates;
    final optimizer = Optimizer(
      tasks: tasks,
      excludedDates: excludedDates,
      workingHours: workingHours,
    );
    Schedule schedule = await optimizer.optimize();

    return schedule;
  }

  Future<void> optimizeAndAdd(BuildContext context) async {
    final state = context.read<AuthBloc>().state;
    Schedule schedule = await optimizeTask(context);

    String uid;
    if (state is LoggedIn) {
      uid = state.user.uid;
    } else {
      uid = "";
    }
    await scheduleRepo.addSchedule(schedule, uid);

    for (Task task in schedule.getTasks) {
      await taskRepo.addTask(task);
    }
  }

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
              Text("add task"),
            ],
          ),

          const InitialTaskList(),
          const SizedBox(height: 40),

          BlocBuilder<TaskAddBloc, TaskAddState>(
            builder: (taskContext, taskState) {
              if (taskState.tasks.isNotEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("Manual Scheduling"),
                    ),
                    TextButton(
                      onPressed: () {
                        optimizeAndAdd(context);
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == null &&
                              route is MaterialPageRoute &&
                              route.builder(context) is CalendarPage,
                        );
                      },
                      child: Text("Automatic Scheduling"),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
