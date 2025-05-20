import 'dart:developer';

import 'package:flutter/material.dart';

class DaysCard extends StatelessWidget {
  final Map<String, double> workingHours;
  const DaysCard({super.key, required this.workingHours});

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    log("card reached");
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(color: Colors.black),
      ),
      color: Colors.white,
      child: Column(
        children: [
          Align(alignment: Alignment.center, child: Text("Working Hours")),
          Divider(),
          ...workingHours.entries.map(
            (entry) => Text("${capitalize(entry.key)}: ${entry.value}"),
          ),
        ],
      ),
    );
  }
}
