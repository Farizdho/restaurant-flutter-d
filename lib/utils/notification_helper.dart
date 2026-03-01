import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Reminder',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      "🍽️ Rekomendasi Restaurant",
      "$title • $body",
      details,
    );
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool> _requestAndroidNotificationsPermission() async {
    return await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    final notificationEnabled = await _isAndroidPermissionGranted();
    if (!notificationEnabled) {
      final requestNotificationsPermission =
          await _requestAndroidNotificationsPermission();
      return requestNotificationsPermission;
    }
    return notificationEnabled;
  }
}
