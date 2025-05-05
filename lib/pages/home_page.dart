import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/widgets/default_appbar.dart';
import 'package:taskora/widgets/task_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppbar(),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (authContext, authState) {
            if (authState is NotLoggedIn) {
              return Text("log in to see tasks");
            } else if (authState is LoggedIn) {
              return BlocBuilder<CalendarBloc, CalendarState>(
                builder: (scheduleContext, scheduleState) {
                  if (scheduleState is CalendarLoaded) {
                    return TaskList();
                  }
                  return Text("error state");
                },
              );
            }
            return Text("error no auth state");
          },
        ),
      ),
    );
  }
}
