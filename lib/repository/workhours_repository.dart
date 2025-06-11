import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:taskora/model/entity/work_hours.dart';

class WorkHoursRepository {
  final baseUrl = "http://10.0.2.2:3000";
  final logHelper = "[WORK HOUR REPO]";
  final Map<String, String> header = {'Content-Type': 'application/json'};

  Future<void> addWorkHours(WorkHours workHours, String uid) async {
    final url = Uri.parse("$baseUrl/workHours/add");
    final body = jsonEncode({"workHours": workHours.toJson(), "uid": uid});

    final response = await http.post(url, headers: header, body: body);

    if (response.statusCode != 200) {
      throw Exception("error from $url :${response.body}");
    }

    log("$logHelper reponse from $url: ${jsonDecode(response.body)}");
  }

  Future<WorkHours> getWorkHoursByUid(String uid) async {
    final url = Uri.parse("$baseUrl/workHours/get/byUid?uid=$uid");

    final response = await http.get(url, headers: header);

    if (response.statusCode != 200) {
      throw Exception("error from $url: ${response.body}");
    }

    log("$logHelper reponse from $url: ${jsonDecode(response.body)}");

    return WorkHours.fromJson(jsonDecode(response.body));
  }
}
