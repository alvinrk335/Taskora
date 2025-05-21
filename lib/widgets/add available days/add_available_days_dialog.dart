import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';

class AddAvailableDaysDialog extends StatefulWidget {
  const AddAvailableDaysDialog({super.key});

  @override
  State<AddAvailableDaysDialog> createState() => _AddAvailableDaysDialogState();
}

class _AddAvailableDaysDialogState extends State<AddAvailableDaysDialog> {
  final mondayController = TextEditingController();
  final tuesdayController = TextEditingController();
  final wednesdayController = TextEditingController();
  final thursdayController = TextEditingController();
  final fridayController = TextEditingController();
  final saturdayController = TextEditingController();
  final sundayController = TextEditingController();

  @override
  void dispose() {
    mondayController.dispose();
    tuesdayController.dispose();
    wednesdayController.dispose();
    thursdayController.dispose();
    fridayController.dispose();
    saturdayController.dispose();
    sundayController.dispose();
    super.dispose();
  }

  Map<String, double> getWorkingHoursData() {
    return {
      "Monday": double.tryParse(mondayController.text) ?? 0,
      "Tuesday": double.tryParse(tuesdayController.text) ?? 0,
      "Wednesday": double.tryParse(wednesdayController.text) ?? 0,
      "Thursday": double.tryParse(thursdayController.text) ?? 0,
      "Friday": double.tryParse(fridayController.text) ?? 0,
      "Saturday": double.tryParse(saturdayController.text) ?? 0,
      "Sunday": double.tryParse(sundayController.text) ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //monday
          Text("Monday"),
          TextField(controller: mondayController),
          SizedBox(height: 10),

          //tuesday
          Text("Tuesday"),
          TextField(controller: tuesdayController),
          SizedBox(height: 10),

          //wednesday
          Text("Wednesday"),
          TextField(controller: wednesdayController),
          SizedBox(height: 10),

          //thursday
          Text("Thursday"),
          TextField(controller: thursdayController),
          SizedBox(height: 10),

          //friday
          Text("Friday"),
          TextField(controller: fridayController),
          SizedBox(height: 10),

          //saturday
          Text("Saturday"),
          TextField(controller: saturdayController),
          SizedBox(height: 10),

          //sunday
          Text("Sunday"),
          TextField(controller: sundayController),
          SizedBox(height: 10),
        ],
      ),

      //actions
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("cancel"),
        ),

        TextButton(
          onPressed: () {
            log("confirm button pressed");
            context.read<AvailableDaysBloc>().add(
              SetWeeklyWorkHours(weeklyHours: getWorkingHoursData()),
            );
            Navigator.pop(context);
          },
          child: Text("confirm"),
        ),
      ],
    );
  }
}
