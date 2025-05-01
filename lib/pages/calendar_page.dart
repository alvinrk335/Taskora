import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/repository/schedule_repository.dart';
import 'package:taskora/widgets/calendar.dart';
// import 'package:taskora/widgets/custom_navbar.dart';
import 'package:taskora/widgets/default_appbar.dart';

class CalendarPage extends StatelessWidget {
  final repo = ScheduleRepository();

  CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc(),
      child: Scaffold(
        appBar: DefaultAppbar(),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<CalendarBloc>().add(ReloadRequest());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Center(child: Calendar())],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.assignment),
        ),
      ),
    );
  }
}
