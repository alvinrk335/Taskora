import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth/auth_event.dart';
import 'package:frontend/bloc/auth/auth_state.dart';
import 'package:frontend/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authService = AuthService();

  AuthBloc() : super(AuthInitial());
  
}
