import 'package:flutter_test/flutter_test.dart';
import 'package:snap_note/main.dart';
import 'package:snap_note/services/snap_repository.dart';

void main() {
  testWidgets('SnapApp smoke test renders app title and empty state',
      (WidgetTester tester) async {
    final repository = SnapRepository();
    await tester.pumpWidget(SnapApp(repository: repository));

    expect(find.text('Snap & Gallery Note'), findsOneWidget);
    expect(find.text('No snapshots yet. Tap capture above!'), findsOneWidget);
  });
}
