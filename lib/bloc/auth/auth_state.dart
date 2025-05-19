
import 'package:taskora/model/entity/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoggedIn extends AuthState {
  final User user;
  LoggedIn(this.user);
}

class NotLoggedIn extends AuthState{}
