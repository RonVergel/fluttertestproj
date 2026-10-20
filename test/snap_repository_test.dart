import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/models/snap_note.dart';
import 'package:snap_note/services/snap_repository.dart';

void main() {
  group('SnapNote Serialization', () {
    test('serializes to and from map with image bytes', () {
      final sampleBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final note = SnapNote(
        id: 'test-101',
        filePath: 'path/photo.jpg',
        imageBytes: sampleBytes,
        timestamp: DateTime(2026, 3, 15, 14, 30),
        caption: 'Sample caption',
      );

      final map = note.toMap();
      final restored = SnapNote.fromMap(map);

      expect(restored.id, equals('test-101'));
      expect(restored.filePath, equals('path/photo.jpg'));
      expect(restored.imageBytes, equals(sampleBytes));
      expect(restored.timestamp, equals(DateTime(2026, 3, 15, 14, 30)));
      expect(restored.caption, equals('Sample caption'));
    });
  });

  group('SnapRepository', () {
    late SnapRepository repository;

    setUp(() {
      repository = SnapRepository();
    });

    test('starts with empty list of notes', () {
      expect(repository.notes, isEmpty);
    });

    test('adds note correctly and maintains newest first order', () async {
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

      await repository.addNote(note1);
      await repository.addNote(note2);

      expect(repository.notes.length, equals(2));
      expect(repository.notes.first.id, equals('2'));
      expect(repository.notes.last.id, equals('1'));
    });

    test('deletes note by id', () async {
      final note = SnapNote(
        id: '1',
        filePath: '/tmp/photo1.jpg',
        timestamp: DateTime(2026, 1, 1, 10, 0),
      );

      await repository.addNote(note);
      expect(repository.notes.length, equals(1));

      final deleted = await repository.deleteNote('1');
      expect(deleted, isTrue);
      expect(repository.notes, isEmpty);
    });

    test('returns false when deleting non-existent id', () async {
      final deleted = await repository.deleteNote('non_existent');
      expect(deleted, isFalse);
    });
  });
}
