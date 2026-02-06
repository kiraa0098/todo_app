import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/common/api/base_api.dart';
import 'package:todo_app/features/account/models/account_user_model.dart';

class AccountApi {
  static Future<http.Response> createAccount(AccountUserModel model) async {
    final apiBaseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$apiBaseUrl/api/account/create');

    final body = jsonEncode({'AccountUserModel': model.toJson()});

    return await BaseApi.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
