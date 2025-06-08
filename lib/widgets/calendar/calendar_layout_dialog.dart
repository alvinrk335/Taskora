import 'package:flutter/material.dart';

class CalendarLayoutDialog extends StatelessWidget {
  const CalendarLayoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Calendar Layout'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle layout selection
                // context.read<CalendarBloc>().add(CalendarFormatChanged(Calendarfo.month));
                Navigator.pop(context);
              },
              child: const Text('month view'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle layout selection
                Navigator.pop(context);
              },
              child: const Text('list view'),
            ),
          ],
        ),
      ),
    );
  }
}
