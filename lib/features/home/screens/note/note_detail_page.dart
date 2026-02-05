import 'package:flutter/material.dart';
import 'package:todo_app/common/helper/secure_storage_helper.dart';
import 'package:todo_app/features/home/api/notes/create_note_api.dart';
import 'package:todo_app/features/home/api/notes/update_note_api.dart';
import 'package:todo_app/features/home/models/note_model.dart';

class NoteDetailPage extends StatefulWidget {
  final NoteModel? note;
  const NoteDetailPage({super.key, this.note});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  bool _hasChanged = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.text ?? '');
  }

  void _onChanged() {
    if (!_hasChanged) setState(() => _hasChanged = true);
  }

  Future<void> _saveNote() async {
    if (_isSaving) return;
    _isSaving = true;

    final userInfo = await SecureStorageHelper.getUserInfo();
    final userId = userInfo['id'] ?? '';
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    final id = widget.note?.id;
    debugPrint("test $id");

    if (widget.note?.id == null && title.isEmpty && body.isEmpty) {
      Navigator.of(context).pop();
      _isSaving = false;
      return;
    }

    if (title.isNotEmpty || body.isNotEmpty) {
      final model = NoteModel(
        id: widget.note?.id,
        userId: userId,
        title: title,
        text: body,
      );
      try {
        if (widget.note?.id == null) {
          await CreateNoteApi.createNote(model);
        } else {
          await UpdateNoteApi.updateNote(model);
        }
        Navigator.of(context).pop(model.id);
        return;
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save note. Please check your connection and try again.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanged) await _saveNote();
        return !_hasChanged;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.next,
                maxLines: 1,
                onChanged: (_) => _onChanged(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 10,
                onChanged: (_) => _onChanged(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
