import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskora/bloc/auth/auth_bloc.dart';
import 'package:taskora/bloc/auth/auth_state.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_event.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_event.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/repository/user_repository.dart';
import 'package:taskora/repository/workhours_repository.dart';
import 'package:taskora/widgets/appbar/default_appbar.dart';

class HomePage extends StatelessWidget {
  final userRepo = UserRepository();
  
  final workHourRepo = WorkHoursRepository();
  HomePage({super.key});

  List<Task> getTodaysTasks(List<Task> tasks) {
    final now = DateTime.now();
    return tasks.where((task) {
      // Check if any workload is scheduled for today
      final hasWorkloadToday = task.workload.keys.any((date) =>
        date.year == now.year && date.month == now.month && date.day == now.day
      );
      // Also include if deadline is today
      final isDeadlineToday = task.deadline != null &&
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

  Widget buildEventCard(Task task) {
    final deadlineStr = task.deadline != null
        ? DateFormat('dd - MM - yyyy').format(task.deadline!)
        : 'No deadline';
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.taskName.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF80CBC4),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Deadline:  $deadlineStr',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Description:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(task.description.value, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Priority: ${task.priority}', style: const TextStyle(color: Colors.white)),
            Text('Type: ${task.type.toString().split('.').last}', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildTodayEventCard(Task task) {
    final deadlineStr = task.deadline != null
        ? DateFormat('dd - MM - yyyy').format(task.deadline!)
        : 'No deadline';
    // Sum all workload for today (ignore time)
    final now = DateTime.now();
    final todayWorkload = task.workload.entries
        .where((entry) =>
            entry.key.year == now.year &&
            entry.key.month == now.month &&
            entry.key.day == now.day)
        .fold<double>(0, (sum, entry) => sum + entry.value.toNumber());
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskName.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF80CBC4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Deadline: $deadlineStr',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              'workload: ${todayWorkload > 0 ? todayWorkload.toInt() : '-'} hrs',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(

      listener: (authContext, authState) async {
        if (authState is LoggedIn) {
          final uid = authState.user.uid;

          // Ambil work hours setelah login
          final workHours = await workHourRepo.getWorkHoursByUid(uid);
          if (!context.mounted) return;

          context.read<AvailableDaysBloc>().add(
            SetWeeklyWorkHours(weeklyHours: workHours.toMap()),
          );

          final calendarState = context.read<CalendarBloc>().state;
          if (calendarState is CalendarInitial) {
            context.read<CalendarBloc>().add(LoadRequest(authState.user.uid));
          }
          userRepo.addUser(authState.user);
        }
      },
      child: Scaffold(
        appBar: DefaultAppbar(),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                            const Text("No events for today.", style: TextStyle(color: Colors.white70)),
                          ...todaysTasks.map(buildTodayEventCard),
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
                            const Text("No upcoming events.", style: TextStyle(color: Colors.white70)),
                          ...upcomingTasks.map(buildEventCard),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text("Schedule empty", style: TextStyle(color: Colors.white70)));
                },
              );
            }
            return const Center(child: Text("Error: no auth state"));
          },
        ),
      ),
    );
  }
}
