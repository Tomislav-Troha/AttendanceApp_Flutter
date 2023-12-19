import 'package:flutter/material.dart';
import 'package:swimming_app_client/Screens/Welcome/welcome_screen.dart';
import 'package:swimming_app_client/Widgets/app_message.dart';
import 'package:swimming_app_client/theme/theme_manager.dart';

import 'Managers/token_manager.dart';

void main() {
  runApp(const MyApp());
  TokenManager.sharedData();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppMessage.navigatorKey,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      darkTheme: themeDark,
      theme: themeLight,
      themeMode: ThemeMode.system,
      title: 'Attendance app',
    );
  }
}
