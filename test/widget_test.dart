import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/main.dart';
import 'package:snap_note/services/snap_repository.dart';
import 'package:snap_note/widgets/camera_viewfinder.dart';

void main() {
  testWidgets('SnapApp smoke test renders full-screen viewfinder without placeholder',
      (WidgetTester tester) async {
    final repository = SnapRepository();
    await tester.pumpWidget(SnapApp(repository: repository));

    expect(find.byType(CameraViewfinder), findsOneWidget);
    expect(find.text('No snapshots yet. Tap capture above!'), findsNothing);
  });
}
