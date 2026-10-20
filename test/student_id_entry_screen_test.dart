import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/screens/student_id_entry_screen.dart';
import 'package:snap_note/services/snap_repository.dart';

void main() {
  group('StudentIdEntryScreen', () {
    testWidgets('renders 6-digit student ID form with UM branding',
        (WidgetTester tester) async {
      final repository = SnapRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: StudentIdEntryScreen(repository: repository),
        ),
      );

      expect(find.text('UM Security Office'), findsOneWidget);
      expect(find.text('Dress Code Inspection'), findsOneWidget);
      expect(find.text('Enter ID number'), findsWidgets);
      expect(find.text('PROCEED TO CAMERA'), findsOneWidget);
      expect(find.text('0/6 digits'), findsOneWidget);
    });

    testWidgets('enforces digits-only and maximum 6 characters',
        (WidgetTester tester) async {
      final repository = SnapRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: StudentIdEntryScreen(repository: repository),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'abc123456789xyz');
      await tester.pump();

      // Non-digits are stripped and limited to 6 digits
      final widget = tester.widget<TextField>(textField);
      expect(widget.controller?.text, equals('123456'));
      expect(find.text('6/6 digits'), findsOneWidget);
    });

    testWidgets('displays validation error if ID is less than 6 digits',
        (WidgetTester tester) async {
      final repository = SnapRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: StudentIdEntryScreen(repository: repository),
        ),
      );

      await tester.enterText(find.byType(TextField), '12345');
      await tester.tap(find.text('PROCEED TO CAMERA'));
      await tester.pump();

      expect(find.text('Please enter a 6-digit ID number'), findsOneWidget);
    });
  });
}
