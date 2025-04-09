import 'package:user_repo/user_repository.dart';

abstract class UserRepo {
  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);
}
