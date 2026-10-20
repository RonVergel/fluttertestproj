import 'dart:collection';
import 'package:hive/hive.dart';
import '../models/snap_note.dart';

class SnapRepository {
  SnapRepository([Box<dynamic>? box]) : _box = box {
    if (_box != null) {
      _loadFromBox();
    }
  }

  static const String boxName = 'snap_notes_box';
  final Box<dynamic>? _box;
  final List<SnapNote> _notes = [];

  UnmodifiableListView<SnapNote> get notes => UnmodifiableListView(_notes);

  void _loadFromBox() {
    _notes.clear();
    for (final raw in _box!.values) {
      if (raw is Map) {
        _notes.add(SnapNote.fromMap(raw));
      }
    }
    _notes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> addNote(SnapNote note) async {
    _notes.insert(0, note);
    if (_box != null) {
      await _box.put(note.id, note.toMap());
    }
  }

  Future<bool> deleteNote(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes.removeAt(index);
      if (_box != null) {
        await _box.delete(id);
      }
      return true;
    }
    return false;
  }

  Future<void> clear() async {
    _notes.clear();
    if (_box != null) {
      await _box.clear();
    }
  }
}
