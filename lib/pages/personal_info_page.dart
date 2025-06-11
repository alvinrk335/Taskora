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

  void _editIntervalsDialog(
    BuildContext context,
    String day,
    List<Map<String, String>> currentIntervals,
  ) {
    final List<Map<String, String>> intervals = List<Map<String, String>>.from(
      currentIntervals,
    );
    void addInterval(StateSetter setState) async {
      TimeOfDay? start = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 8, minute: 0),
      );
      if (start == null) return;
      TimeOfDay? end = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: start.hour + 1, minute: start.minute),
      );
      if (end == null) return;
      final newStartMinutes = start.hour * 60 + start.minute;
      final newEndMinutes = end.hour * 60 + end.minute;
      if (newEndMinutes <= newStartMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time.')),
        );
        return;
      }
      // Check for overlap with existing intervals
      final overlaps = intervals.any((interval) {
        final partsStart = interval['start']!.split(":");
        final partsEnd = interval['end']!.split(":");
        final s = TimeOfDay(
          hour: int.parse(partsStart[0]),
          minute: int.parse(partsStart[1]),
        );
        final e = TimeOfDay(
          hour: int.parse(partsEnd[0]),
          minute: int.parse(partsEnd[1]),
        );
        final sMin = s.hour * 60 + s.minute;
        final eMin = e.hour * 60 + e.minute;
        return newStartMinutes < eMin && newEndMinutes > sMin;
      });
      if (overlaps) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Intervals cannot overlap.')),
        );
        return;
      }
      intervals.add({
        'start': start.format(context),
        'end': end.format(context),
      });
      setState(() {});
    }

    void removeInterval(int idx) {
      intervals.removeAt(idx);
    }

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (dialogContext, setState) => AlertDialog(
                  title: Text('Edit $day Intervals'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...intervals.asMap().entries.map(
                          (entry) => Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${entry.value['start']} - ${entry.value['end']}',
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                ),
                                onPressed:
                                    () => setState(
                                      () => removeInterval(entry.key),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            addInterval(setState);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Interval'),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AvailableDaysBloc>().add(
                          EditWeeklyWorkInterval(
                            day: day,
                            intervals: List<Map<String, String>>.from(
                              intervals,
                            ),
                          ),
                        );
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
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
                    "Weekly Work Intervals",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...state.weeklyWorkIntervals.entries.map(
                    (entry) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(capitalize(entry.key)),
                        subtitle:
                            entry.value.isEmpty
                                ? const Text("No intervals set")
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      entry.value
                                          .map(
                                            (interval) => Text(
                                              "${interval['start']} - ${interval['end']}",
                                            ),
                                          )
                                          .toList(),
                                ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed:
                              () => _editIntervalsDialog(
                                context,
                                entry.key,
                                entry.value,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                      final workingIntervals =
                          context
                              .read<AvailableDaysBloc>()
                              .state
                              .weeklyWorkIntervals;
                      final state = context.read<AuthBloc>().state;
                      String uid = "";
                      if (state is LoggedIn) {
                        uid = state.user.uid;
                      }
                      await repo.addWorkHours(
                        WorkHours(weeklyWorkIntervals: workingIntervals),
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
          return FloatingActionButton(
            onPressed: () => _pickDate(context),
            tooltip: "Add Excluded Date",
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
