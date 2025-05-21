import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/available_days/available_days_state.dart';
<<<<<<< HEAD
=======
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
>>>>>>> master
import 'package:taskora/pages/add_schedule.dart';
import 'package:taskora/widgets/add%20available%20days/add_available_days_dialog.dart';
import 'package:taskora/widgets/add%20available%20days/days_card.dart';

class AddDaysPage extends StatefulWidget {
  const AddDaysPage({super.key});

  @override
  State<AddDaysPage> createState() => _AddDaysPageState();
}

class _AddDaysPageState extends State<AddDaysPage> {
  DateTime? excludedDay;

  Future<void> _selectDate() async {
    log("select date reached");
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );

<<<<<<< HEAD

    
=======
>>>>>>> master
    if (picked != null) {
      setState(() {
        excludedDay = picked;
      });
      if (mounted) {
        context.read<AvailableDaysBloc>().add(
          AddAvailableDate(date: excludedDay ?? DateTime.now()),
        );
      }
    }
  }

<<<<<<< HEAD

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (_) => AddAvailableDaysDialog(),
                    ),
                icon: Icon(Icons.add),
              ),
              Center(child: Text("Add your daily working hours")),
            ],
          ),
          BlocBuilder<AvailableDaysBloc, AvailableDaysState>(
            builder: (daysContext, daysState) {
              if (daysState.weeklyWorkHours.isNotEmpty) {
                log("weeklyWorkHours: ${daysState.weeklyWorkHours}");
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DaysCard(workingHours: daysState.weeklyWorkHours),
                  
=======
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableDaysBloc, AvailableDaysState>(
      builder: (context, state) {
        final hasWorkHours = state.weeklyWorkHours.values.any((v) => v != 0);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AddAvailableDaysDialog(),
                    ),
                    icon: Icon(
                      hasWorkHours ? Icons.edit : Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    hasWorkHours ? 'Edit your daily working hours' : 'Add your daily working hours',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              if (state.weeklyWorkHours.isNotEmpty) ...[
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DaysCard(workingHours: state.weeklyWorkHours),
>>>>>>> master
                      const SizedBox(height: 70),
                      const Text("Add specific excluded dates (optional)"),
                      const SizedBox(height: 30),
                      TextField(
                        readOnly: true,
                        onTap: () => _selectDate(),
                        decoration: const InputDecoration(
                          hintText: "Leave blank if no excluded dates",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
<<<<<<< HEAD
                  
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Dates : \n${daysState.dates.map((e) => e.toString()).join("\n")}",
=======
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Dates : \n${state.dates.map((e) => e.toString()).join("\n")}",
>>>>>>> master
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
<<<<<<< HEAD
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSchedule(),
                                  ),
                                ),
                            child: Text("next"),
=======
                            onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => TaskAddBloc(),
                                  child: AddSchedule(),
                                ),
                              ),
                              (route) => false,
                            ),
                            child: Text("done"),
>>>>>>> master
                          ),
                        ],
                      ),
                    ],
                  ),
<<<<<<< HEAD
                );
              } else if (daysState.weeklyWorkHours.isEmpty) {
                return Center(
                  child: Text("Please add your daily working hours"),
                );
              }
              return Text("error no state");
            },
          ),
        ],
      ),
=======
                ),
              ] else if (state.weeklyWorkHours.isEmpty) ...[
                Center(
                  child: Text("Please add your daily working hours"),
                ),
              ] else ...[
                Text("error no state"),
              ],
            ],
          ),
        );
      },
>>>>>>> master
    );
  }
}
