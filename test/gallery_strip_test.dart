import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/models/snap_note.dart';
import 'package:snap_note/widgets/gallery_strip.dart';

void main() {
  group('GalleryStrip Widget', () {
    testWidgets('renders nothing when notes list is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GalleryStrip(
              notes: [],
              onSelectNote: null,
            ),
          ),
        ),
      );

      expect(find.byType(GalleryItemCard), findsNothing);
      expect(find.text('No snapshots yet. Tap capture above!'), findsNothing);
    });

    testWidgets('renders note cards when notes are provided',
        (WidgetTester tester) async {
      final notes = [
        SnapNote(
          id: 'note-1',
          filePath: 'mock/path1.jpg',
          timestamp: DateTime(2026, 1, 1, 14, 30),
          caption: 'Shot 1',
        ),
      ];

      SnapNote? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GalleryStrip(
              notes: notes,
              onSelectNote: (note) {
                selected = note;
              },
            ),
          ),
        ),
      );

      expect(find.text('14:30:00'), findsOneWidget);
      await tester.tap(find.text('14:30:00'));
      expect(selected?.id, equals('note-1'));
    });
  });
}

