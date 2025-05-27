import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/available_days/available_days_state.dart';
import 'package:intl/intl.dart';
import 'package:taskora/model/entity/work_hours.dart';
import 'package:taskora/repository/workhours_repository.dart';

class PersonalInfoPage extends StatelessWidget {
  final repo = WorkHoursRepository();
  PersonalInfoPage({super.key});

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('EEE, dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AvailableDaysBloc, AvailableDaysState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weekly Work Hours",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.weeklyWorkHours.isEmpty)
                    Text(
                      "Work hours are empty.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    )
                  else
                    ...state.weeklyWorkHours.entries.map((entry) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(capitalize(entry.key)),
                          subtitle: Text("${entry.value} hours"),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed:
                                () => _editWorkHourDialog(
                                  context,
                                  entry.key,
                                  entry.value,
                                ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),

                  // Excluded Dates section shown only if not empty
                  if (state.dates.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Excluded Dates",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _pickDate(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...state.dates.map((date) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(formatter.format(date)),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              context.read<AvailableDaysBloc>().add(
                                RemoveAvailableDate(date: date),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                  ElevatedButton(
                    onPressed: () async {
                      final workHours =
                          context
                              .read<AvailableDaysBloc>()
                              .state
                              .weeklyWorkHours;

                      final state = context.read<AuthBloc>().state;
                      String uid = "";
                      if (state is LoggedIn) {
                        uid = state.user.uid;
                      }
                      await repo.addWorkHours(
                        WorkHours.fromMap(workHours),
                        uid,
                      );
                    },
                    child: Text("confirm"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<AvailableDaysBloc, AvailableDaysState>(
        builder: (context, state) {
          // Tampilkan tombol tambah excluded date bahkan jika tidak ada excluded dates
          return FloatingActionButton(
            onPressed: () => _pickDate(context),
            tooltip: "Add Excluded Date",
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  void _editWorkHourDialog(
    BuildContext context,
    String day,
    double currentHour,
  ) {
    final controller = TextEditingController(text: currentHour.toString());

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Edit $day"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Working hours",
                suffixText: "hrs",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final newHours = double.tryParse(controller.text);
                  if (newHours != null && newHours >= 0) {
                    context.read<AvailableDaysBloc>().add(
                      EditWeeklyWorkHour(day: day, hours: newHours),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      context.read<AvailableDaysBloc>().add(AddAvailableDate(date: picked));
    }
  }
}
