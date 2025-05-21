import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_event.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
<<<<<<< HEAD
=======
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
>>>>>>> master
import 'package:taskora/pages/profile_page.dart';

class DefaultAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
<<<<<<< HEAD
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
=======
      leading: IconButton(
        onPressed: () {
          context.read<CalendarBloc>().add(ReloadRequest());
        },
        icon: Icon(Icons.menu),
      ),
>>>>>>> master
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (authContext, authState) {
            if (authState is LoggedIn) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                icon: CircleAvatar(
                  radius: 18, // smaller circle

                  backgroundImage: NetworkImage(authState.user.profilePicture),
                ),
              );
            } else {
              return ElevatedButton(
                onPressed: () {
                  authContext.read<AuthBloc>().add(LogIn());
                },
                child: Text("LOGIN"),
<<<<<<< HEAD

=======
>>>>>>> master
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
