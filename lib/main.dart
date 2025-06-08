import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_bloc.dart';
import 'package:taskora/bloc/theme/theme_bloc.dart';
import 'package:taskora/bloc/theme/theme_state.dart';
import 'package:taskora/pages/login_prompt_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<NavbarBloc>(create: (_) => NavbarBloc()),
        BlocProvider(create: (_) => CalendarBloc()),
        BlocProvider(create: (_) => AvailableDaysBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Taskora',
          theme: themeState.theme,
          home: const LoginPromptPage(),
        );
      },
    );
  }
}

