import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:frontend/model/schedule.dart';

class ScheduleRepository {
  final String baseUrl = 'http://localhost:3000';
  final Map<String, String> header = {'Content-Type': 'application/json'};

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
}
