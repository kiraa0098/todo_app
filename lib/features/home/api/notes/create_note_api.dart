import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_app/common/api/base_api.dart';
import 'package:todo_app/features/home/models/note_model.dart';

class CreateNoteApi {
  static Future<NoteModel> createNote(NoteModel model) async {
    final apiBaseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$apiBaseUrl/api/create-note');
    final body = jsonEncode({'NoteModel': model.toJson()});
    final response = await BaseApi.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data['data'] is Map) {
        return NoteModel.fromJson(data['data']);
      }
    }
    throw Exception('Failed to create note');
  }
}
