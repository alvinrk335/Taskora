import 'package:flutter/material.dart';

class DefaultAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? profilePic;
  final VoidCallback? onLogin;
  const DefaultAppbar({super.key, this.profilePic = "", this.onLogin});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      actions: [
        if (profilePic == null || profilePic!.isEmpty)
          TextButton(
            onPressed: onLogin,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(width: 2.0),
            ),
            child: const Text("Login", style: TextStyle(color: Colors.black))
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(backgroundImage: NetworkImage(profilePic!)),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
