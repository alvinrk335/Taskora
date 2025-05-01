import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskora/bloc/auth/auth_event.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authService = AuthService();

  AuthBloc() : super(NotLoggedIn()) {
    on<LogIn>((event, emit) async {
      log("Event LogIn diterima");
      try {
        final googleUser = await authService.signInWithGoogle();
        if (googleUser != null) {
          log("User berhasil login: ${googleUser.username}");
          emit(LoggedIn(googleUser));
        } else {
          log("Login dibatalkan atau gagal.");
        }
      } catch (e) {
        log(e.toString());
      }
    });
    on<LogOut>((event, emit) async {
      await GoogleSignIn().signOut();
      log("berhasil logout");
      emit(NotLoggedIn());
    });
  }
}
