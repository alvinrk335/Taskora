import 'dart:convert';
import 'dart:developer';

import 'package:taskora/model/entity/initial_task.dart';
import 'package:http/http.dart' as http;
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/services/id_generator.dart';

class Optimizer {
  final List<InitialTask> tasks;
  final Map<String, List<Map<String, String>>> workingIntervals;
  final List<DateTime> excludedDates;
  final int threshold = 6; // 4-6 banyak break, 7-10 sedang, 11+ berat
  final int daysToSchedule = 100;
  final String? request;
  final bool? newSchedule;
  final String? scheduleId;

  final String baseUrl = "http://10.0.2.2:3000";
  final Map<String, String> header = {"Content-Type": "application/json"};
  final String logHelper = "[OPTIMIZER]";
  Optimizer({
    required this.tasks,
    required this.workingIntervals,
    required this.excludedDates,
    this.request,
    this.newSchedule,
    this.scheduleId,
  });

  Future<Schedule> optimize() async {
    final url = Uri.parse("$baseUrl/schedule/optimize");
    String scheduleId;
    if (newSchedule ?? true) {
      scheduleId = await generateId("schedule");
    } else {
      scheduleId = this.scheduleId ?? "";
    }
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    final excludedDatesString =
        excludedDates.map((date) => date.toIso8601String()).toList();

    final bodyJson = jsonEncode({
      "request": request ?? "",
      "scheduleId": scheduleId,
      "listOfTask": tasksJson,
      "weeklyWorkingIntervals": workingIntervals,
      "excludedDates": excludedDatesString,
      "daysToSchedule": daysToSchedule,
      "workloadThreshold": threshold,
    });
    log("$logHelper input to $url: $bodyJson");
    final response = await http.post(url, headers: header, body: bodyJson);

    log("$logHelper response from $url: ${response.body}");
    if (response.statusCode != 200) {
      log("error ${response.statusCode}");
      throw Exception("Failed to optimize schedule: ${response.reasonPhrase}");
    }
    return Schedule.fromJson(jsonDecode(response.body));
  }
}
