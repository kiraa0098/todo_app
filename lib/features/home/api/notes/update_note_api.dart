import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/common/api/base_api.dart';
import 'package:todo_app/features/home/models/note_model.dart';

class UpdateNoteApi {
  static Future<http.Response> updateNote(NoteModel model) async {
    final apiBaseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$apiBaseUrl/api/update-note');
    final body = jsonEncode({'NoteModel': model.toJson()});
    return await BaseApi.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
