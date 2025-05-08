import 'dart:convert';
import 'dart:developer';

import 'package:taskora/model/initial_task.dart';
import 'package:http/http.dart' as http;
import 'package:taskora/model/schedule.dart';

class Optimizer {
  final List<InitialTask> tasks;
  final Map<String, double> workingHours;
  final List<DateTime> excludedDates;
  final int threshold = 6; // 4-6 banyak break, 7-10 sedang, 11+ berat
  final int daysToSchedule = 100;

  final String baseUrl = "http://10.0.2.2:3000";
  final Map<String, String> header = {'Content-Type': 'application/json'};

  Optimizer({
    required this.tasks,
    required this.workingHours,
    required this.excludedDates,
  });

  Future<Schedule> optimize() async {
    final url = Uri.parse("$baseUrl/schedule/optimize");
    
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    log("input: $tasksJson");
  
    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode({
        "listOfTask": tasksJson,
        "weeklyWorkingHours": workingHours,
        "excludedDays": excludedDates,
        "daysToSchedule": daysToSchedule,
        "workloadThreshold": threshold,
      }),
    );

    log("response from $url: ${response.body}");
    return Schedule.fromJson(jsonDecode(response.body));
  }
}
