import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_app/common/api/base_api.dart';
import 'package:todo_app/features/home/models/note_model.dart';

class GetNotesById {
  static Future<List<NoteModel>> getNotesByUserId(
    BuildContext context,
    String userId,
  ) async {
    try {
      final apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
      final url = Uri.parse('$apiBaseUrl/api/get-notes-by-id');
      final response = await BaseApi.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => NoteModel.fromJson(e))
              .toList();
        }
      }

      debugPrint("test get notes by id response: ${response.body}");
      return [];
    } catch (e) {
      if (e == BaseApi.connectionErrorTag) {
        throw BaseApi.connectionErrorTag;
      }
      rethrow;
    }
  }
}
