// import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:taskora/model/user.dart' as model;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<model.User?> signInWithGoogle() async {
    try {
      log("ginginginlogiiiiiin");
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("user adalah null");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final firebase.AuthCredential credential = firebase
          .GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      firebase.UserCredential userCred = await firebase.FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCred.user!;

      model.User userModel = model.User(
        uid: user.uid,
        username: user.displayName!,
        email: user.email!,
        profilePicture: user.photoURL!,
      );
      return userModel;
    } on Exception catch (e) {
      log(e.toString());
      throw Exception("login failed");
    }
  }
}
