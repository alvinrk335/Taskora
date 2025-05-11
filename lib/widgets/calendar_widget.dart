import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskora/model/task.dart';

class CalendarWidget extends StatefulWidget {
  final Map<DateTime, List<Task>> events;
  const CalendarWidget({super.key, required this.events});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: visible ? 350 : 0,
        height: visible ? 400 : 0,
        child: TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime(DateTime.now().year, DateTime.now().month, 1),
          lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
          eventLoader: (day) => widget.events[day] ?? [],
        ),
      ),
    );
  }
}
