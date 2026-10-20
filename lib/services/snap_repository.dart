import 'dart:collection';
import '../models/snap_note.dart';

class SnapRepository {
  final List<SnapNote> _notes = [];

  UnmodifiableListView<SnapNote> get notes => UnmodifiableListView(_notes);

  void addNote(SnapNote note) {
    _notes.insert(0, note);
  }

  bool deleteNote(String id) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes.removeAt(index);
      return true;
    }
    return false;
  }

  void clear() {
    _notes.clear();
  }
}
