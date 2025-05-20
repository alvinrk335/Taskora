import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_state.dart';
import 'package:taskora/bloc/task_priority/task_priority_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_bloc.dart';
import 'package:taskora/model/entity/initial_task.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/entity/work_hours.dart';
import 'package:taskora/pages/navigation.dart';
import 'package:taskora/repository/schedule_repository.dart';
import 'package:taskora/repository/task_repository.dart';
import 'package:taskora/repository/workhours_repository.dart';
import 'package:taskora/services/optimizer.dart';
import 'package:taskora/widgets/add%20schedule/add_task_body.dart';
import 'package:taskora/widgets/add%20schedule/initial_task_list.dart';

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
  final workHoursRepo = WorkHoursRepository();

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
<<<<<<< HEAD
=======

>>>>>>> 19e03416083a52dbc55c65818d121799ce284671
    Schedule schedule = await optimizeTask(context);

    String uid;
    if (state is LoggedIn) {
      uid = state.user.uid;
    } else {
      uid = "";
    }
    await scheduleRepo.addScheduleWithTask(schedule, uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
                              child: const AddOrEditTaskDialog(),
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
                      onPressed: () async {
                        //get working hour from state
                        final Map<String, double> workingHours =
                            context
                                .read<AvailableDaysBloc>()
                                .state
                                .weeklyWorkHours;
                        //get uid
                        final authState = context.read<AuthBloc>().state;
                        String uid = "";
                        if (authState is LoggedIn) {
                          uid = authState.user.uid;
                        }
                        await workHoursRepo.addWorkHours(
                          WorkHours.fromMap(workingHours),
                          uid,
                        );

                        if (!context.mounted) return;
                        optimizeAndAdd(context);
                        context.read<CalendarBloc>().add(ReloadRequest());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Navigation()),
                          (route) => false,
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
