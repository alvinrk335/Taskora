import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/theme/theme_bloc.dart';
import 'package:taskora/pages/personal_info_page.dart';
import 'package:taskora/pages/setting_page.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({super.key});

  NetworkImage getProfile(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is LoggedIn) {
      return NetworkImage(state.user.profilePicture);
    }
    return NetworkImage("");
  }

  Text getName(BuildContext context, TextStyle? style) {
    final state = context.read<AuthBloc>().state;
    if (state is LoggedIn) {
      return Text(state.user.username, style: style);
    }
    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //profile
                CircleAvatar(backgroundImage: getProfile(context), radius: 40),
                const SizedBox(height: 20),
                //name
                getName(context, TextStyle(fontSize: 24)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Personal Info'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<AvailableDaysBloc>(),
                        child: PersonalInfoPage(),
                      ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<ThemeBloc>(),
                        child: SettingPage(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
