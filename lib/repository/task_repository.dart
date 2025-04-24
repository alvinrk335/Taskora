import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/model/task.dart';

class TaskRepository {
  final String baseUrl = 'http://localhost:3000'; // Ganti dengan URL backend Anda

  // Method untuk mendapatkan task berdasarkan taskId
  Future<Task?> getTask(String taskId) async {
    final url = Uri.parse('$baseUrl/task/get');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final taskData = jsonDecode(response.body);
      return Task.fromJson(taskData);  // Parsing response JSON ke model Task
    } else {
      throw Exception('Failed to load task');
    }
  }

  // Method untuk menambahkan task baru
  Future<void> addTask(Task task) async {
    final url = Uri.parse('$baseUrl/task/add');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(task.toJson()),  // Mengirim task dalam format JSON
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }
  }

  // Method untuk memperbarui task
  Future<void> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/task/edit');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(task.toJson()),  // Mengirim data task yang sudah diupdate
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  // Method untuk menerjemahkan task
  Future<Map<String, dynamic>> translateTask(Map<String, dynamic> taskData) async {
    final url = Uri.parse('$baseUrl/task/translate');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(taskData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to translate task');
    }
  }
}
