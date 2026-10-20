import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/widgets/camera_viewfinder.dart';

void main() {
  group('CameraViewfinder', () {
    testWidgets('hides flash and flip buttons on laptop without flash or second camera',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraViewfinder(
              controller: null,
              isInitialized: false,
              isCapturing: false,
              isFlashSupported: false,
              canSwitchCamera: false,
              onCapture: () {},
              onSwitchCamera: () {},
              onToggleFlash: () {},
              currentFlashMode: FlashMode.off,
            ),
          ),
        ),
      );

      expect(find.byType(FlashModeButton), findsNothing);
      expect(find.byIcon(Icons.flip_camera_ios), findsNothing);
      expect(find.byType(ShutterButton), findsOneWidget);
    });

    testWidgets('shows flash and flip buttons when supported on mobile',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraViewfinder(
              controller: null,
              isInitialized: true,
              isCapturing: false,
              isFlashSupported: true,
              canSwitchCamera: true,
              onCapture: () {},
              onSwitchCamera: () {},
              onToggleFlash: () {},
              currentFlashMode: FlashMode.auto,
            ),
          ),
        ),
      );

      expect(find.byType(FlashModeButton), findsOneWidget);
      expect(find.byIcon(Icons.flip_camera_ios), findsOneWidget);
    });

    testWidgets('renders active student ID badge and responds to taps',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraViewfinder(
              controller: null,
              isInitialized: true,
              isCapturing: false,
              isFlashSupported: false,
              canSwitchCamera: false,
              activeStudentId: '2024-00123',
              onTapStudentId: () => tapped = true,
              onCapture: () {},
              onSwitchCamera: () {},
              onToggleFlash: () {},
              currentFlashMode: FlashMode.off,
            ),
          ),
        ),
      );

      expect(find.text('ID: 2024-00123'), findsOneWidget);
      await tester.tap(find.text('ID: 2024-00123'));
      expect(tapped, isTrue);
    });
  });
}
