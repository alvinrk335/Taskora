import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_bloc.dart';
// import 'package:taskora/pages/calendar_page.dart';
import 'package:taskora/pages/navigation.dart';

void main() async {
  // await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (_) =>
                  AuthBloc(), // Pastikan ini tidak null & sudah diinisialisasi dengan benar
        ),
        BlocProvider<NavbarBloc>(create: (_) => NavbarBloc()),

        BlocProvider(create: (_) => CalendarBloc()),

        BlocProvider(create: (_) => AvailableDaysBloc())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Taskora', home: Navigation());
  }
}
