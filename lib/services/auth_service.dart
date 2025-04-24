import 'dart:convert';
import 'package:frontend/model/User.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final String token = googleAuth.idToken!;

    final response = await http.post(
      Uri.parse("http://localhost:3000/auth/login"),
      headers: {"content-type": "application/JSON"},
      body: jsonEncode({"token": token}),
    );

    final userModel = User.fromJson(jsonDecode(response.body));

    return userModel;
  }
}
