import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/bloc/task_preview/task_preview_bloc.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/pages/navigation.dart';
import 'package:taskora/repository/schedule_repository.dart';
import 'package:taskora/widgets/task%20preview/task_preview_list.dart';

class TaskPreview extends StatelessWidget {
  final repo = ScheduleRepository();
  TaskPreview({super.key});

  @override
  Widget build(BuildContext context) {
    Schedule schedule = context.select(
      (TaskPreviewBloc bloc) => bloc.state.schedule,
    );
    final oldScheduleState = context.read<CalendarBloc>().state;
    Schedule oldSchedule = Schedule.empty();
    if (oldScheduleState is CalendarLoaded) {
      oldSchedule = oldScheduleState.schedule;
    }
    log("[TASK PREVIEW] in task preview : ${schedule.toJson()}");
    final authState = context.read<AuthBloc>().state;
    String uid = "";
    if (authState is LoggedIn) {
      uid = authState.user.uid;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Edited Task Preview",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                TaskPreviewList(),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );
                        
                        try {
                          // First update the schedule
                          await repo.removeScheduleWithTask(oldSchedule);
                          await repo.addScheduleWithTask(schedule, uid);

                          if (!context.mounted) return;

                          // Trigger a calendar reload before navigation
                          context.read<CalendarBloc>().add(ReloadRequest());
                          
                          // Add a small delay to allow the calendar to reload
                          await Future.delayed(const Duration(milliseconds: 100));
                          
                          // Close loading dialog and navigate home
                          if (!context.mounted) return;
                          Navigator.pop(context); // Close loading dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Navigation()),
                            (route) => false,
                          );
                          
                          if (!context.mounted) return;
                          
                          // Close loading dialog and navigate home
                          Navigator.pop(context); // Close loading dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Navigation()),
                            (route) => false,
                          );
                        } catch (e) {
                          // If error, close loading and show error
                          if (context.mounted) {
                            Navigator.pop(context); // Close loading dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error updating schedule: $e')),
                            );
                          }
                        }
                      },
                      child: Text("Confirm Changes"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
