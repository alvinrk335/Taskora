import 'package:flutter/material.dart';
// import 'package:frontend/widgets/default_appbar.dart';

class HomePage extends StatelessWidget implements PreferredSizeWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: DefaultAppbar("Home"),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}