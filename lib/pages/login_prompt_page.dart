import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_event.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/pages/navigation.dart';

class LoginPromptPage extends StatelessWidget {
  const LoginPromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (authContext, authState) {
        if (authState is LoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => Navigation()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please login to proceed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w300, // Thinner font
                ),
              ),
              const SizedBox(height: 16), // reduced space between text and button
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(LogIn());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // slightly larger padding
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(22), // slightly larger radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.2),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.12),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                    border: Border.all(color: Colors.white10, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 22, // slightly larger icon
                        height: 22,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1E1E1E),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.asset(
                            'lib/Assets/GoogleLogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // slightly larger gap
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 13, // slightly larger font
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
