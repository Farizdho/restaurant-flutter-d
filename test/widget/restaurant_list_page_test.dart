import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_dicoding/ui/pages/restaurant_list_page.dart';
import 'package:restaurant_dicoding/provider/restaurant_list_provider.dart';
import 'package:restaurant_dicoding/data/api/api_service.dart';

void main() {
  testWidgets('Should show loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => RestaurantListProvider(ApiService()),
        child: const MaterialApp(home: RestaurantListPage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
