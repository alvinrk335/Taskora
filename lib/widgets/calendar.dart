import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (authContext, authState) {
        if (authState is LoggedIn) {
          return BlocBuilder<CalendarBloc, CalendarState>(
            builder: (scheduleContext, scheduleState) {
              if (scheduleState is CalendarLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (scheduleState is CalendarLoaded) {
                final events = scheduleState.loadEvent();
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        1,
                      ),
                      lastDay: DateTime(
                        DateTime.now().year,
                        DateTime.now().month + 1,
                        0,
                      ),
                      eventLoader: (day) => events[day] ?? [],
                    ),
                  ),
                );
              } else if (scheduleState is CalendarInitial) {
                final uid = authState.user.uid;
                scheduleContext.read<CalendarBloc>().add(LoadRequest(uid));
              } else if (scheduleState is CalendarEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TableCalendar(
                          focusedDay: DateTime.now(),
                          firstDay: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            1,
                          ),
                          lastDay: DateTime(
                            DateTime.now().year,
                            DateTime.now().month + 1,
                            0,
                          ),
                        ),
                        const Divider(color: Colors.transparent, height: 20),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "No schedule found, insert new schedule data by clicking the task button on the bottom right corner of the screen",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text("error fetching data"));
            },
          );
        } else if (authState is NotLoggedIn) {
          return Center(child: Text("log in to see schedule"));
        }
        return const Center(child: Text("data"));
      },
    );
  }
}
