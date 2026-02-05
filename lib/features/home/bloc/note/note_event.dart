import 'package:equatable/equatable.dart';

import '../../models/note_model.dart';

abstract class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNotes extends NoteEvent {}

class DeleteNote extends NoteEvent {
  final NoteModel note;
  DeleteNote(this.note);
  @override
  List<Object?> get props => [note];
}
