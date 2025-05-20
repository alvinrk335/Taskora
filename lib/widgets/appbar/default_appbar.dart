import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_event.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/pages/profile_page.dart';

class DefaultAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
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
                child: Text("Login"),

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
