

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_event.dart';
import 'package:taskora/bloc/navbar/navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavigationState> {
  NavbarBloc() : super(NavigationState(0)) {
    on<MoveTo>((event, emit) {
      emit(NavigationState(event.index));
      log("moved to page ${event.index}");
    });
  }
}
