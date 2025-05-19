import 'dart:convert';
import 'dart:developer';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/entity/task.dart';

class ScheduleRepository {
  final String baseUrl = "http://10.0.2.2:3000";
  final Map<String, String> header = {'Content-Type': 'application/json'};
  final String logHelper = "[SCHEDULE REPO]";

  Future<Map<String, dynamic>> getSchedule(String scheduleId) async {
    final url = Uri.parse('$baseUrl/schedule/get?scheduleId=$scheduleId');
    final response = await http.get(url, headers: header);

    if (response.statusCode != 200) {
      throw Exception("failed getting schedule from server");
    }
    final schedule = jsonDecode(response.body);
    return schedule;
  }

  Future<void> addSchedule(Schedule schedule, String uid) async {
    final url = Uri.parse('$baseUrl/schedule/add');
    final response = await http.post(
      url,
      headers: header,
      body: json.encode({"schedule": schedule, "uid": uid}),
    );
    log(response.body);

    if (response.statusCode != 200) {
      throw Exception("failed getting schedule from server");
    }
  }

  Future<Schedule> getScheduleByUid(String uid) async {
    try {
      final url = Uri.parse('$baseUrl/schedule/getByUid?uid=$uid');
      log("$logHelper url: $url");
      final response = await http.get(url, headers: header);
      log("$logHelper response from $url : ${response.body}");

      if (response.statusCode == 300) {
        return Schedule.empty();
      }
      if (response.statusCode != 200) {
        throw Exception("failed getting schedule from server");
      }
      log("$logHelper ${jsonDecode(response.body)}");
      final decoded = jsonDecode(response.body);

      final scheduleId = decoded['scheduleId'];
      log("$logHelper scheduleID: $scheduleId");
      final List<String> taskIds = List<String>.from(decoded['taskIds']);

      final List<Task> tasks = [];

      for (String taskId in taskIds) {
        final taskResponse = await http.get(
          Uri.parse('$baseUrl/task/getById?taskId=$taskId'),
          headers: header,
        );

        if (taskResponse.statusCode == 200) {
          final taskJson = jsonDecode(taskResponse.body);
          tasks.add(Task.fromJson(taskJson));
        } else {
          log("$logHelper Failed to fetch task $taskId");
        }
      }
      final schedule = Schedule(scheduleId: scheduleId, tasks: tasks);
      log("$logHelper schedule returned: ${schedule.toJson()}");
      return schedule;
    } catch (e) {
      log(e.toString());
      return Schedule.empty();
    }
  }

  Future<void> addTaskToSchedule(
    String scheduleId,
    String taskId,
    String uid,
  ) async {
    final url = Uri.parse('$baseUrl/schedule/addTask');
    final response = await http.put(
      url,
      headers: header,
      body: json.encode({
        "scheduleId": scheduleId,
        "taskId": taskId,
        "uid": uid,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("failed editing schedule from server");
    }

    log(response.body);
  }

  Future<void> deleteTaskInSchedule(String scheduleId, String taskId) async {
    final url = Uri.parse('$baseUrl/schedule/deleteTask');
    final response = await http.delete(
      url,
      headers: header,
      body: jsonEncode({"scheduleId": scheduleId, "taskId": taskId}),
    );

    if (response.statusCode != 200) {
      throw Exception("failed editing schedule from server");
    }

    log(response.body);
  }

  Future<void> addScheduleWithTask(Schedule schedule, String uid) async {
    final url = Uri.parse("$baseUrl/schedule/add/withTask");
    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode({"schedule": schedule, "uid": uid}),
    );
    if (response.statusCode != 200) {
      throw Exception("failed editing schedule from server");
    }
    log("response from $url: ${jsonDecode(response.body)}");
  }

}
