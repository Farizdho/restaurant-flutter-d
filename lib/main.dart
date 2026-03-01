import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'ui/pages/restaurant_list_page.dart';

import 'package:provider/provider.dart';
import 'data/api/api_service.dart';
import 'provider/restaurant_list_provider.dart';

import 'provider/theme_provider.dart';

import 'package:workmanager/workmanager.dart';
import 'utils/background_service.dart';
import 'utils/notification_helper.dart';

import './provider/reminder_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ init notification
  await NotificationHelper().init();

  // ✅ init workmanager
  await Workmanager().initialize(callbackDispatcher);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const RestaurantListPage(),
          );
        },
      ),
    );
  }
}
