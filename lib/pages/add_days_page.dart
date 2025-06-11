import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/available_days/available_days_state.dart';
import 'package:taskora/bloc/task_add/task_add_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder: (_) => const AddAvailableDaysDialog(),
                      ),
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Add your daily working hours",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<AvailableDaysBloc, AvailableDaysState>(
              builder: (daysContext, daysState) {
                if (daysState.weeklyWorkIntervals.isNotEmpty) {
                  log("$daysState");
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DaysCard(workingIntervals: daysState.weeklyWorkIntervals),
                          const SizedBox(height: 40),
                          Text(
                            "Add specific excluded dates (optional)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            readOnly: true,
                            onTap: () => _selectDate(),
                            decoration: const InputDecoration(
                              hintText: "Leave blank if no excluded dates",
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (daysState.dates.isNotEmpty)
                            if (daysState.dates.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...daysState.dates.map(
                                    (date) => Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<AvailableDaysBloc>()
                                                  .add(
                                                    RemoveAvailableDate(
                                                      date: date,
                                                    ),
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                          const SizedBox(height: 32),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BlocProvider(
                                          create: (_) => TaskAddBloc(),
                                          child: const AddSchedule(),
                                        ),
                                  ),
                                );
                              },
                              child: const Text("Next"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text("Please add your daily working hours"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
