import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/entity/task.dart';

class CalendarWidget extends StatefulWidget {
  final Map<DateTime, List<Task>> events;
  const CalendarWidget({super.key, required this.events});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  bool visible = false;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        visible = true;
      });
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    context.read<CalendarBloc>().add(DaySelected(daySelected: selectedDay));
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  List<Task> _getEventsForDay(DateTime day) {
    return widget.events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (calendarContext, calendarState) {
        DateTime? selectedDay;
        if (calendarState is CalendarLoaded) {
          selectedDay = calendarState.selectedDay;
        }

        return SingleChildScrollView(
          child: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  1,
                ),
                lastDay: DateTime(
                  DateTime.now().year + 30,
                  DateTime.now().month,
                  0,
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                eventLoader: (day) => _getEventsForDay(day),
                onDaySelected: _onDaySelected,
              ),
            ),
          ),
        );
      },
    );
  }
}
