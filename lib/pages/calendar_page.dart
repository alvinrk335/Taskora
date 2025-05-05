import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/pages/task_page.dart';
import 'package:taskora/repository/schedule_repository.dart';
import 'package:taskora/widgets/calendar.dart';

import 'package:taskora/widgets/default_appbar.dart';
import 'package:taskora/widgets/task_list.dart';

class CalendarPage extends StatelessWidget {
  final repo = ScheduleRepository();

  CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppbar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CalendarBloc>().add(ReloadRequest());
        },
        child: Column(
          children: [
            Center(child: Calendar()),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (authContext, authState) {
                if (authState is NotLoggedIn) {
                  return SizedBox.shrink();
                } else if (authState is LoggedIn) {
                  return TaskList();
                }
                return Text("data");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (schedulecontext, scheduleState) {
          if (scheduleState is CalendarLoaded) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: context.read<CalendarBloc>(),
                          child: TaskPage(),
                        ),
                  ),
                );
              },
              child: Icon(Icons.assignment),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
