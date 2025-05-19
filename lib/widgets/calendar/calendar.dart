import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';

import 'package:taskora/widgets/calendar/calendar_widget.dart';

class Calendar extends StatelessWidget {
  final logHelper = "[CALENDAR]";
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (authContext, authState) {
        if (authState is LoggedIn) {
          return BlocBuilder<CalendarBloc, CalendarState>(
            builder: (scheduleContext, calendarState) {
              if (calendarState is CalendarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (calendarState is CalendarLoaded) {
                log(
                  "$logHelper schedule loaded into calendar : ${calendarState.schedule.toJson()}",
                );
                final events = calendarState.loadEvent();
                log("$logHelper events loaded : $events");
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CalendarWidget(events: events),
                );
              } else if (calendarState is CalendarInitial) {
                final uid = authState.user.uid;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final currentState = context.read<CalendarBloc>().state;
                  if (currentState is CalendarInitial) {
                    log(
                      "$logHelper Triggering LoadRequest dari CalendarInitial",
                    );
                    scheduleContext.read<CalendarBloc>().add(LoadRequest(uid));
                  }
                });
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text("error fetching data"));
              }
            },
          );
        } else {
          return const Center(child: Text("log in to see schedule"));
        }
      },
    );
  }
}
