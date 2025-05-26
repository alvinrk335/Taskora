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

  Widget buildDayInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: "Enter hours",
          prefixIcon: Icon(Icons.access_time),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade600,
            ), // lebih soft
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 0.5, color: Colors.grey),
          ),
          hintStyle: TextStyle(color: Colors.white24),
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black38,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Set Weekly Work Hours",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDayInput("Monday", mondayController),
            buildDayInput("Tuesday", tuesdayController),
            buildDayInput("Wednesday", wednesdayController),
            buildDayInput("Thursday", thursdayController),
            buildDayInput("Friday", fridayController),
            buildDayInput("Saturday", saturdayController),
            buildDayInput("Sunday", sundayController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            log("confirm button pressed");
            context.read<AvailableDaysBloc>().add(
              SetWeeklyWorkHours(weeklyHours: getWorkingHoursData()),
            );
            Navigator.pop(context);
          },
          icon: Icon(Icons.check),
          label: Text("Confirm"),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
