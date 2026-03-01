import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';

import '../../provider/reminder_provider.dart';

class RestaurantSettings extends StatelessWidget {
  const RestaurantSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: context.watch<ThemeProvider>().isDarkTheme,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
          ),

          SwitchListTile(
            title: const Text('Daily Lunch Reminder'),
            subtitle: const Text('Jam 11 siang'),
            value: reminderProvider.isReminderActive,
            onChanged: (value) {
              reminderProvider.toggleReminder(value);
            },
          ),
        ],
      ),
    );
  }
}
