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
  final Map<String, List<Map<String, String>>> intervals = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  void _addInterval(String day) async {
    DateTime now = DateTime.now();
    TimeOfDay? start = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
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
    final overlaps = intervals[day]!.any((interval) {
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
      // Overlap if: (start < eMin && end > sMin)
      return newStartMinutes < eMin && newEndMinutes > sMin;
    });
    if (overlaps) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Intervals cannot overlap.')),
      );
      return;
    }
    setState(() {
      intervals[day]!.add({
        'start': formatTimeOfDay(start),
        'end': formatTimeOfDay(end),
      });
    });
  }

  void _removeInterval(String day, int idx) {
    setState(() {
      intervals[day]!.removeAt(idx);
    });
  }

  Widget buildDayIntervalInput(String day, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(day, style: theme.textTheme.titleMedium),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addInterval(day),
              tooltip: 'Add interval',
            ),
          ],
        ),
        ...intervals[day]!.asMap().entries.map((entry) {
          final idx = entry.key;
          final interval = entry.value;
          return Row(
            children: [
              Expanded(
                child: Text('${interval['start']} - ${interval['end']}'),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent),
                onPressed: () => _removeInterval(day, idx),
                tooltip: 'Remove interval',
              ),
            ],
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        "Set Weekly Work Intervals",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDayIntervalInput('Monday', theme),
            buildDayIntervalInput('Tuesday', theme),
            buildDayIntervalInput('Wednesday', theme),
            buildDayIntervalInput('Thursday', theme),
            buildDayIntervalInput('Friday', theme),
            buildDayIntervalInput('Saturday', theme),
            buildDayIntervalInput('Sunday', theme),
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
            context.read<AvailableDaysBloc>().add(
              SetWeeklyWorkIntervals(weeklyIntervals: intervals),
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
