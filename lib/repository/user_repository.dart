import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:taskora/model/entity/user.dart';

class UserRepository {
  final String baseUrl = "http://10.0.2.2:3000";
  final String logHelper = "[USER REPOSITORY]";
  final Map<String, String> header = {'Content-Type': 'application/json'};

  Future<void> addUser(User user) async {
    final url = Uri.parse("$baseUrl/auth/add");
    log("input diterima $url: ${user.toJson()}");
    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode({"user": user.toJson()}),
    );

    if (response.statusCode != 200) {
      throw Exception("error from $url");
    }
    log("$logHelper response: ${jsonDecode(response.body)}");
  }
}
