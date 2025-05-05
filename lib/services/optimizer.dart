import 'dart:convert';
import 'dart:developer';

import 'package:taskora/model/initial_task.dart';
import 'package:http/http.dart' as http;

class Optimizer {
  final List<InitialTask> tasks;
  final String baseUrl = "http://10.0.2.2:3000";
  final Map<String, String> header = {'Content-Type': 'application/json'};

  Optimizer({required this.tasks});

  void optimize() async {
    final url = Uri.parse("$baseUrl/schedule/optimize");
    final tasksJson = tasks.map((task) => task.toJson()).toList();

    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode({"listOfTasks": tasksJson}),
    );

    log("response from $url: $response");
  }
}
