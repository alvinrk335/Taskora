import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskora/Assets/colors/app_colors.dart';
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
    // Normalize to year/month/day to match event keys
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return widget.events[normalizedDay] ?? [];
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
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                eventLoader: (day) => _getEventsForDay(day),
                onDaySelected: _onDaySelected,
                availableGestures: AvailableGestures.all,

                // Header Style (bulan & tahun)
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.text,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.text,
                  ),
                ),

                // Teks nama hari
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: AppColors.text),
                  weekendStyle: TextStyle(color: AppColors.accent),
                ),

                // Style angka tanggal
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: AppColors.text),
                  weekendTextStyle: TextStyle(color: AppColors.accent),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(color: Colors.white),
                  outsideDaysVisible: false,
                ),

                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final normalizedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                    );
                    final hasEvents =
                        widget.events[normalizedDate]?.isNotEmpty ?? false;
                    if (hasEvents) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
