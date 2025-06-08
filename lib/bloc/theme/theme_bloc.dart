import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/Assets/colors/dark_theme.dart';
import 'package:taskora/Assets/colors/light_theme.dart';
import 'package:taskora/bloc/theme/theme_events.dart';
import 'package:taskora/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvents, ThemeState> {
  ThemeBloc() : super(ThemeState(theme: lightTheme())) {
    on<SetLightTheme>((event, emit) => emit(ThemeState(theme: lightTheme())));

    on<SetDarkTheme>((event, emit) => emit(ThemeState(theme: darkTheme())));
  }
}