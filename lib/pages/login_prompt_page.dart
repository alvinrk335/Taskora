import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_event.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_bloc.dart';
import 'package:taskora/bloc/theme/theme_bloc.dart';
import 'package:taskora/pages/navigation.dart';

class LoginPromptPage extends StatelessWidget {
  const LoginPromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (authContext, authState) {
        if (authState is LoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<NavbarBloc>()),
                      BlocProvider.value(value: context.read<ThemeBloc>()),
                      BlocProvider.value(value: context.read<CalendarBloc>()),
                      BlocProvider.value(
                        value: context.read<AvailableDaysBloc>(),
                      ),
                    ],
                    child: Navigation(),
                  ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Press login to proceed',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300, // Thinner font
                ),
              ),
              const SizedBox(
                height: 16,
              ), // reduced space between text and button
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(child: CircularProgressIndicator()),
                  );
                  context.read<AuthBloc>().add(LogIn());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ), // slightly larger padding
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      22,
                    ), // slightly larger radius
                    border: Border.all(width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 22, // slightly larger icon
                        height: 22,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image(
                            image: AssetImage('lib/Assets/GoogleLogo.png'),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none, // No blur
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(
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
