import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/repository/user_repository.dart';
import 'package:taskora/repository/workhours_repository.dart';
import 'package:taskora/widgets/home%20page/all_event_list.dart';
import 'package:taskora/widgets/home%20page/today_event_list.dart';

class HomePage extends StatelessWidget {
  final userRepo = UserRepository();

  final workHourRepo = WorkHoursRepository();
  HomePage({super.key});

  List<Task> getTodaysTasks(List<Task> tasks) {
    final now = DateTime.now();
    final todayStr = "YYYY-MM-DD"
        .replaceRange(0, 4, now.year.toString().padLeft(4, '0'))
        .replaceRange(5, 7, now.month.toString().padLeft(2, '0'))
        .replaceRange(8, 10, now.day.toString().padLeft(2, '0'));
    return tasks.where((task) {
      // Check if any workload is scheduled for today (interval-based)
      final hasWorkloadToday =
          task.workload.containsKey(todayStr) &&
          (task.workload[todayStr]?.isNotEmpty ?? false);
      // Also include if deadline is today
      final isDeadlineToday =
          task.deadline != null &&
          task.deadline!.year == now.year &&
          task.deadline!.month == now.month &&
          task.deadline!.day == now.day;
      return hasWorkloadToday || isDeadlineToday;
    }).toList();
  }

  List<Task> getUpcomingTasks(List<Task> tasks) {
    final now = DateTime.now();
    return tasks.where((task) {
      if (task.deadline == null) return false;
      final d = task.deadline!;
      return d.isAfter(DateTime(now.year, now.month, now.day));
    }).toList();
  }

  String prioFromNumber(int prio) {
    if (prio == 1) {
      return "low";
    } else if (prio == 2) {
      return "medium";
    } else if (prio == 3) {
      return "high";
    }
    return "invalid priority";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (authContext, authState) {
          if (authState is NotLoggedIn) {
            return const Center(child: Text("login to see tasks"));
          } else if (authState is LoggedIn) {
            return BlocBuilder<CalendarBloc, CalendarState>(
              builder: (scheduleContext, scheduleState) {
                if (scheduleState is CalendarLoaded) {
                  final allTasks = scheduleState.schedule.getTasks;
                  final todaysTasks = getTodaysTasks(allTasks);
                  final upcomingTasks = getUpcomingTasks(allTasks);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Events",
                          style: TextStyle(
                            color: Color(0xFFFFB74D),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (todaysTasks.isEmpty)
                          const Text("No events for today."),
                        ...todaysTasks.map(
                          (task) => TodayEventList(task: task),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          "Upcoming Events",
                          style: TextStyle(
                            color: Color(0xFFFFB74D),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (upcomingTasks.isEmpty)
                          const Text(
                            "No upcoming events.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ...upcomingTasks.map(
                          (task) => AllEventList(task: task),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    "Schedule empty",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Error: no auth state"));
        },
      ),
    );
  }
}
