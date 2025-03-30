import 'package:flutter/material.dart';

class DefaultAppbar extends StatelessWidget {
  final String? pageTitle;
  final String profilePic;
  const DefaultAppbar({super.key, this.pageTitle, this.profilePic = ""});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(pageTitle ?? "", style: TextStyle(fontSize: 20)),
      actions: [CircleAvatar(backgroundImage: NetworkImage(profilePic),)],
    );
  }
}
