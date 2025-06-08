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

  Widget buildDayInput(
    String label,
    TextEditingController controller,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: "Enter hours",
          prefixIcon: Icon(Icons.access_time),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 0.5, color: theme.dividerColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 0.5, color: theme.dividerColor),
          ),
          filled: true,
          // Background input box
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        "Set Weekly Work Hours",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDayInput("Monday", mondayController, theme),
            buildDayInput("Tuesday", tuesdayController, theme),
            buildDayInput("Wednesday", wednesdayController, theme),
            buildDayInput("Thursday", thursdayController, theme),
            buildDayInput("Friday", fridayController, theme),
            buildDayInput("Saturday", saturdayController, theme),
            buildDayInput("Sunday", sundayController, theme),
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
