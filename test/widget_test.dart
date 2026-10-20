import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/main.dart';
import 'package:snap_note/screens/student_id_entry_screen.dart';
import 'package:snap_note/services/snap_repository.dart';
import 'package:snap_note/widgets/camera_viewfinder.dart';

void main() {
  testWidgets('SnapApp renders StudentIdEntryScreen first and navigates to Camera on submit',
      (WidgetTester tester) async {
    final repository = SnapRepository();
    await tester.pumpWidget(SnapApp(repository: repository));

    expect(find.byType(StudentIdEntryScreen), findsOneWidget);
    expect(find.text('Enter ID number'), findsWidgets);
    expect(find.text('PROCEED TO CAMERA'), findsOneWidget);

    // Try tapping without ID - validation should prevent proceeding to camera
    await tester.tap(find.text('PROCEED TO CAMERA'));
    await tester.pump();
    expect(find.text('Please enter a 6-digit ID number'), findsOneWidget);
    expect(find.byType(CameraViewfinder), findsNothing);

    // Enter 6-digit ID and proceed
    await tester.enterText(find.byType(TextField), '123456');
    await tester.tap(find.text('PROCEED TO CAMERA'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Camera screen is displayed with ID badge
    expect(find.byType(CameraViewfinder), findsOneWidget);
    expect(find.text('ID: 123456'), findsOneWidget);
  });
}
