import 'dart:io';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Icon(Icons.catching_pokemon_rounded, size: 200, color: Colors.red,)));
  }
}
