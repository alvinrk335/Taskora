// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/repository/schedule_repository.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final repo = ScheduleRepository();
  CalendarBloc() : super(CalendarInitial()) {
    on<LoadRequest>((event, emit) async {
      try {
        emit(CalendarLoading());
        log("calendar loading");
        final schedule = await repo.getScheduleByUid(event.uid);
        emit(CalendarLoaded(schedule: schedule));
        log("calendar loaded");
      } catch (e) {
        log(e.toString());
      }
    });

    on<DeloadRequest>((event, emit) {
      log("Calendar deloaded");
      emit(CalendarInitial());
    });

    on<ReloadRequest>((event, emit) => emit(CalendarInitial()));

    on<DaySelected>((event, emit) {
      final currState = state;
      if (currState is CalendarLoaded) {
        // If event.daySelected is null, deselect (set selectedDay to null)
        emit(currState.copyWith(selectedDay: event.daySelected));
      }
    });
    on<CalendarFormatChanged>((event, emit) {
      final currState = state;
      if (currState is CalendarLoaded) {
        emit(currState.copyWith(calendarFormat: event.calendarFormat));
      }
    });
  }
}
