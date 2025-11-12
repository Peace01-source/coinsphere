// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:coins_sphere/main.dart';
import 'package:coins_sphere/screens/main_navigation_screen.dart';

void main() {
  testWidgets('CoinSphere app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CoinSphereApp());
    await tester.pumpAndSettle();
    // The MainNavigationScreen should be present as the initial screen.
    expect(find.byType(MainNavigationScreen), findsOneWidget);
  });
}
