import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_event.dart';
import 'package:taskora/bloc/auth/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        
        builder: (authContext, authState) {
          if (authState is LoggedIn) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          authState.user.profilePicture,
                        ),
                        radius: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.user.username,
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              authState.user.email,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 93, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () => authContext.read<AuthBloc>().add(LogOut()),
                          child: Text("log out"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (authState is NotLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
            return const SizedBox();
          }
          return Center(child: Text("error"));
        },
      ),
    );
  }
}
