import 'package:flutter/material.dart';

class DefaultAppbar extends StatelessWidget implements PreferredSizeWidget{
  const DefaultAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}