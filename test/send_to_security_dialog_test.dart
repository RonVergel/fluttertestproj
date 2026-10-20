import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/widgets/send_to_security_dialog.dart';

void main() {
  group('SendToSecurityDialog', () {
    final sampleBytes = Uint8List.fromList([1, 2, 3]);

    testWidgets('renders preview and SEND TO SECURITY OFFICE button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SendToSecurityDialog(
              imageBytes: sampleBytes,
              filePath: 'test/path.jpg',
            ),
          ),
        ),
      );

      expect(find.text('SEND TO SECURITY OFFICE'), findsOneWidget);
      expect(find.text('Retake'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('returns remarks when SEND TO SECURITY OFFICE is tapped',
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
                    builder: (_) => SendToSecurityDialog(
                      imageBytes: sampleBytes,
                      filePath: 'test/path.jpg',
                    ),
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
        'Inappropriate attire - no ID',
      );
      await tester.tap(find.text('SEND TO SECURITY OFFICE'));
      await tester.pumpAndSettle();

      expect(result, equals('Inappropriate attire - no ID'));
    });
  });
}
