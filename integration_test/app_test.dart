import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_dicoding/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('app smoke test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Restaurant List'), findsOneWidget);
    });

    testWidgets('should show restaurant list item', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('tap restaurant item should navigate to detail', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final listTile = find.byType(ListTile).first;
      await tester.tap(listTile);
      await tester.pumpAndSettle();

      expect(find.text('Detail Restaurant'), findsOneWidget);
    });
  });
}
