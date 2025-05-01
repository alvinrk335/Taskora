import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_event.dart';
import 'package:taskora/bloc/navbar/navbar_state.dart';
import 'package:taskora/pages/calendar_page.dart';
import 'package:taskora/pages/home_page.dart';

class Navigation extends StatelessWidget {
  Navigation({super.key});

  final List<Widget> pages = [HomePage(), CalendarPage()];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavbarBloc(),
      child: BlocBuilder<NavbarBloc, NavigationState>(
        builder: (navigationContext, navigationState) {
          return Scaffold(
            body: pages[navigationState.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) => navigationContext.read<NavbarBloc>().add(MoveTo(index)),
              currentIndex: navigationState.currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "home_page",
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: "calendar_page",
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
