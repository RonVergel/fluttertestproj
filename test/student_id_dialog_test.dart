import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/widgets/student_id_dialog.dart';

void main() {
  group('StudentIdInputDialog', () {
    testWidgets('renders autofocus Student ID field and action buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StudentIdInputDialog(),
          ),
        ),
      );

      expect(find.text('Enter ID number'), findsWidgets);
      expect(find.text('PROCEED TO CAMERA'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
      expect(textField.decoration?.labelText, equals('Enter ID number'));
    });

    testWidgets('returns entered student ID on submission',
        (WidgetTester tester) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<String>(
                    context: context,
                    builder: (_) => const StudentIdInputDialog(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '654321',
      );
      await tester.tap(find.text('PROCEED TO CAMERA'));
      await tester.pumpAndSettle();

      expect(result, equals('654321'));
    });
  });
}
