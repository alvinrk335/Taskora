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
        final schedule = await repo.getScheduleByUid(event.uid);
        if (schedule.isEmpty()) {
          emit(CalendarEmpty());
        } else {
          emit(CalendarLoaded(schedule));
        }
      } catch (e) {
        log(e.toString());
      }
    });

    on<DeloadRequest>((event, emit) => emit(CalendarEmpty()));

    on<ReloadRequest>((event, emit) => emit(CalendarInitial()));
  }
}
