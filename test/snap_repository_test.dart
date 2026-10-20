import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/models/snap_note.dart';
import 'package:snap_note/services/snap_repository.dart';

void main() {
  group('SnapRepository', () {
    late SnapRepository repository;

    setUp(() {
      repository = SnapRepository();
    });

    test('starts with empty list of notes', () {
      expect(repository.notes, isEmpty);
    });

    test('adds note correctly and maintains newest first order', () {
      final note1 = SnapNote(
        id: '1',
        filePath: '/tmp/photo1.jpg',
        timestamp: DateTime(2026, 1, 1, 10, 0),
        caption: 'First photo',
      );
      final note2 = SnapNote(
        id: '2',
        filePath: '/tmp/photo2.jpg',
        timestamp: DateTime(2026, 1, 1, 11, 0),
        caption: 'Second photo',
      );

      repository.addNote(note1);
      repository.addNote(note2);

      expect(repository.notes.length, equals(2));
      expect(repository.notes.first.id, equals('2'));
      expect(repository.notes.last.id, equals('1'));
    });

    test('deletes note by id', () {
      final note = SnapNote(
        id: '1',
        filePath: '/tmp/photo1.jpg',
        timestamp: DateTime(2026, 1, 1, 10, 0),
      );

      repository.addNote(note);
      expect(repository.notes.length, equals(1));

      final deleted = repository.deleteNote('1');
      expect(deleted, isTrue);
      expect(repository.notes, isEmpty);
    });

    test('returns false when deleting non-existent id', () {
      final deleted = repository.deleteNote('non_existent');
      expect(deleted, isFalse);
    });
  });
}

