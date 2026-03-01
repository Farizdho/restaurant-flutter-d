import 'package:workmanager/workmanager.dart';

class WorkmanagerHelper {
  static const String taskName = 'dailyReminderTask';

  /// 🔥 register reminder
  static Future<void> registerDailyReminder() async {
    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// ❌ cancel reminder
  static Future<void> cancelDailyReminder() async {
    await Workmanager().cancelByUniqueName(taskName);
  }

  /// ⏰ hitung delay ke jam 11 siang
  static Duration _calculateInitialDelay() {
    final now = DateTime.now();
    final elevenAM = DateTime(now.year, now.month, now.day, 11);

    if (now.isAfter(elevenAM)) {
      return elevenAM.add(const Duration(days: 1)).difference(now);
    } else {
      return elevenAM.difference(now);
    }
  }
}
