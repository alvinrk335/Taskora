import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_bloc.dart';
import 'package:taskora/bloc/navbar/navbar_event.dart';
import 'package:taskora/bloc/navbar/navbar_state.dart';
import 'package:taskora/pages/calendar_page.dart';
import 'package:taskora/pages/home_page.dart';
import 'package:taskora/widgets/appbar/default_appbar.dart';
import 'package:taskora/widgets/menu/burger_menu.dart';

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
            appBar: DefaultAppbar(),
            drawer: BurgerMenu(),
            body: pages[navigationState.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap:
                  (index) =>
                      navigationContext.read<NavbarBloc>().add(MoveTo(index)),
              currentIndex: navigationState.currentIndex,
              items: [
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
      ),
    );
  }
}
