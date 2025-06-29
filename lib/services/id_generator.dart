import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

final baseUrl = "http://10.0.2.2:3000";
final Map<String, String> header = {'Content-Type': 'application/json'};
Future<String> generateId(String type) async {
  final url = Uri.parse("$baseUrl/id/get?type=$type");
  log("input: $url");
  try {
    final response = await http.get(url, headers: header);

    log("Response from $url: ${response.body}");

    if (response.statusCode != 200) {
      log('Failed to get ID, status code: ${response.statusCode}');
      return 'Error';
    }
    final data = jsonDecode(response.body);
    return data['Id'];
  } catch (e) {
    log('Error occurred: $e');
    return 'Error';
  }
}
