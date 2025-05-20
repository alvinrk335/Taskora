import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';
import 'package:taskora/repository/user_repository.dart';
import 'package:taskora/repository/workhours_repository.dart';
import 'package:taskora/widgets/appbar/default_appbar.dart';
import 'package:taskora/widgets/task%20list/task_info_dialog.dart';
import 'package:taskora/widgets/task%20list/task_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final userRepo = UserRepository();

  final workHourRepo = WorkHoursRepository();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (authContext, authState) async {
        if (authState is LoggedIn) {
          final uid = authState.user.uid;

          // Ambil work hours setelah login
          final workHours = await workHourRepo.getWorkHoursByUid(uid);
          if (!context.mounted) return;

          context.read<AvailableDaysBloc>().add(
            SetWeeklyWorkHours(weeklyHours: workHours.toMap()),
          );

          final calendarState = context.read<CalendarBloc>().state;
          if (calendarState is CalendarInitial) {
            context.read<CalendarBloc>().add(LoadRequest(authState.user.uid));
          }
          userRepo.addUser(authState.user);
        }
      },
      child: Scaffold(
        appBar: DefaultAppbar(),
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (authContext, authState) {
              if (authState is NotLoggedIn) {
                return Text("log in to see tasks");
              } else if (authState is LoggedIn) {
                return Column(
                  children: [
                    BlocBuilder<CalendarBloc, CalendarState>(
                      builder: (scheduleContext, scheduleState) {
                        if (scheduleState is CalendarLoaded) {
                          return TaskList(
                            cardType: CardType.button,
                            onTap: (task) {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder:
                                    (ctx) => TaskInfoDialog(
                                      summaryType: SummaryType.full,
                                      task: task,
                                    ),
                              );
                            },
                            summaryType: SummaryType.compact,
                            showAll: true,
                          );
                        }
                        return Text("schedule empty");
                      },
                    ),
                  ],
                );
              }
              return Text("error no auth state");
            },
          ),
        ),
      ),
    );
  }
}
