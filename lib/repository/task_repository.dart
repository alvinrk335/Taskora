import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:taskora/model/task.dart';

class TaskRepository {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<Task?> getTask(String taskId) async {
    final url = Uri.parse('$baseUrl/task/getById?taskId=$taskId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final taskData = jsonDecode(response.body);
      return Task.fromJson(taskData); // Parsing response JSON ke model Task
    } else {
      throw Exception('Failed to load task');
    }
  }

  Future<void> addTask(Task task) async {
    final url = Uri.parse('$baseUrl/task/add');
    log("sending requet to add task ${task.taskId} into $url");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    log("response from $url: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(Task data) async {
    final url = Uri.parse('$baseUrl/task/edit');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"task": data.toJson()}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<Map<String, dynamic>> translateTask(
    Map<String, dynamic> taskData,
  ) async {
    final url = Uri.parse('$baseUrl/task/translate');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to translate task');
    }
  }
}
