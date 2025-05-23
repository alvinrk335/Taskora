import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/pages/task_page.dart';
import 'package:taskora/repository/schedule_repository.dart';
import 'package:taskora/widgets/calendar/calendar.dart';

import 'package:taskora/widgets/task%20list/task_list.dart';

class CalendarPage extends StatelessWidget {
  final repo = ScheduleRepository();

  CalendarPage({super.key});

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<CalendarBloc>()),
              BlocProvider.value(value: context.read<AvailableDaysBloc>()),
            ],
            child: TaskPage(),
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CalendarBloc>().add(ReloadRequest());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Calendar()),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (authContext, authState) {
                  if (authState is NotLoggedIn) {
                    return SizedBox.shrink();
                  } else if (authState is LoggedIn) {
                    return TaskList(cardType: CardType.regular, compact: true);
                  }
                  return Text("data");
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (schedulecontext, scheduleState) {
          if (scheduleState is CalendarLoaded) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
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
