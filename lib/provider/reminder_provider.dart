import 'package:flutter/material.dart';
import 'package:restaurant_dicoding/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/workmanager_helper.dart';

class ReminderProvider extends ChangeNotifier {
  static const _key = 'DAILY_REMINDER';

  bool _isActive = false;
  bool get isReminderActive => _isActive;

  ReminderProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isActive = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    await NotificationHelper().requestPermissions();
    final prefs = await SharedPreferences.getInstance();

    _isActive = value;
    await prefs.setBool(_key, value);

    if (value) {
      await WorkmanagerHelper.registerDailyReminder();
    } else {
      await WorkmanagerHelper.cancelDailyReminder();
    }

    notifyListeners();
  }
}
