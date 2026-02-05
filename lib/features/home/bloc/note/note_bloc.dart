import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/common/helper/secure_storage_helper.dart';

import '../../api/notes/delete_note_api.dart';
import '../../api/notes/get_notes_by_id.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final BuildContext context;
  NoteBloc(this.context) : super(NoteInitial()) {
    on<FetchNotes>(_onFetchNotes);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onFetchNotes(FetchNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final userInfo = await SecureStorageHelper.getUserInfo();
      final userId = userInfo['id'] ?? '';
      final notes = await GetNotesById.getNotesByUserId(context, userId);
      notes.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      await DeleteNoteApi.deleteNote(event.note);
      add(FetchNotes());
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }
}
