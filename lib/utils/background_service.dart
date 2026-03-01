import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'notification_helper.dart';

const dailyTask = "dailyReminderTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == dailyTask) {
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/list'),
      );

      final jsonData = json.decode(response.body);
      final restaurants = jsonData['restaurants'];

      restaurants.shuffle();
      final restaurant = restaurants.first;

      await NotificationHelper().showNotification(
        restaurant['name'],
        restaurant['city'],
      );
    }

    return Future.value(true);
  });
}
