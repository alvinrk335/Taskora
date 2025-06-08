import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/bloc/navbar/navbar_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_event.dart';
import 'package:taskora/bloc/navbar/navbar_state.dart';
import 'package:taskora/pages/calendar_page.dart';
import 'package:taskora/pages/home_page.dart';
import 'package:taskora/repository/user_repository.dart';
import 'package:taskora/repository/workhours_repository.dart';
import 'package:taskora/widgets/appbar/default_appbar.dart';
import 'package:taskora/widgets/menu/burger_menu.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final userRepo = UserRepository();
  final workHourRepo = WorkHoursRepository();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeAfterLogin();
      _initialized = true;
    }
  }

  void _initializeAfterLogin() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is LoggedIn) {
      final uid = authState.user.uid;
      final workHours = await workHourRepo.getWorkHoursByUid(uid);
      if (!mounted) return;

      context.read<AvailableDaysBloc>().add(
        SetWeeklyWorkHours(weeklyHours: workHours.toMap()),
      );

      final calendarState = context.read<CalendarBloc>().state;
      if (calendarState is CalendarInitial) {
        log("[NAVIGATION] triggering load request");
        context.read<CalendarBloc>().add(LoadRequest(uid));
      }

      userRepo.addUser(authState.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavigationState>(
      builder: (navigationContext, navigationState) {
        final List<Widget> pages = [HomePage(), CalendarPage()];

        return Scaffold(
          appBar: DefaultAppbar(),
          drawer: BurgerMenu(),
          body: pages[navigationState.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) =>
                navigationContext.read<NavbarBloc>().add(MoveTo(index)),
            currentIndex: navigationState.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Calendar",
                backgroundColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
