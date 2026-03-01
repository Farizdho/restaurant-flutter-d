import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_dicoding/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app smoke test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Restaurant List'), findsOneWidget);
  });
}
