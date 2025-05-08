import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/available_days/available_days_state.dart';

class AvailableDaysBloc extends Bloc<AvailableDaysEvent, AvailableDaysState> {
  AvailableDaysBloc()
    : super(const AvailableDaysState(dates: [], weeklyWorkHours: {})) {
    on<SetAvailableDates>((event, emit) {
      emit(
        AvailableDaysState(
          dates: event.dates,
          weeklyWorkHours: state.weeklyWorkHours,
        ),
      );
    });

    on<AddAvailableDate>((event, emit) {
      final updatedDates = [...state.dates];
      if (!updatedDates.contains(event.date)) {
        updatedDates.add(event.date);
      }
      emit(
        AvailableDaysState(
          dates: updatedDates,
          weeklyWorkHours: state.weeklyWorkHours,
        ),
      );
    });

    on<RemoveAvailableDate>((event, emit) {
      final updatedDates = state.dates.where((d) => d != event.date).toList();
      emit(
        AvailableDaysState(
          dates: updatedDates,
          weeklyWorkHours: state.weeklyWorkHours,
        ),
      );
    });

    on<SetWeeklyWorkHours>((event, emit) {
      log("event set weekly hours diterima");
      emit(
        AvailableDaysState(
          dates: state.dates,
          weeklyWorkHours: event.weeklyHours,
        ),
      );
      log("emitted state baru : ${state.dates}, ${state.weeklyWorkHours}");
    });

    on<EditWeeklyWorkHour>((event, emit) {
      final updatedHours = Map<String, double>.from(state.weeklyWorkHours);
      updatedHours[event.day] = event.hours;
      emit(
        AvailableDaysState(dates: state.dates, weeklyWorkHours: updatedHours),
      );
    });
  }
}
