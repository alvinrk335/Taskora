import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/available_days/available_days_state.dart';

class AvailableDaysBloc extends Bloc<AvailableDaysEvent, AvailableDaysState> {
  AvailableDaysBloc()
    : super(const AvailableDaysState(dates: [], weeklyWorkIntervals: {})) {
    on<SetAvailableDates>((event, emit) {
      emit(
        AvailableDaysState(
          dates: event.dates,
          weeklyWorkIntervals: state.weeklyWorkIntervals,
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
          weeklyWorkIntervals: state.weeklyWorkIntervals,
        ),
      );
    });

    on<RemoveAvailableDate>((event, emit) {
      final updatedDates = state.dates.where((d) => d != event.date).toList();
      emit(
        AvailableDaysState(
          dates: updatedDates,
          weeklyWorkIntervals: state.weeklyWorkIntervals,
        ),
      );
    });

    on<SetWeeklyWorkIntervals>((event, emit) {
      emit(
        AvailableDaysState(
          dates: state.dates,
          weeklyWorkIntervals: event.weeklyIntervals,
        ),
      );
    });

    on<EditWeeklyWorkInterval>((event, emit) {
      final updated = Map<String, List<Map<String, String>>>.from(
        state.weeklyWorkIntervals,
      );
      updated[event.day] = event.intervals;
      emit(
        AvailableDaysState(dates: state.dates, weeklyWorkIntervals: updated),
      );
    });
  }
}
