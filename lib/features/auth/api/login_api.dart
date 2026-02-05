import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/common/api/base_api.dart';
import 'package:todo_app/features/auth/models/login_model.dart';

class LoginApi {
  static Future<http.Response> login(LoginModel model) async {
    final apiBaseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$apiBaseUrl/api/auth/login');
    final body = jsonEncode({'LoginModel': model.toJson()});
    return await BaseApi.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
