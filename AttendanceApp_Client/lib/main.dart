import 'package:flutter/material.dart';
import 'package:swimming_app_client/Screens/Login/login_screen.dart';
import 'package:swimming_app_client/Screens/Welcome/welcome_screen.dart';
import 'package:swimming_app_client/Widgets/app_message.dart';
import 'package:swimming_app_client/screens/splash/splash_screen.dart';
import 'package:swimming_app_client/theme/theme_manager.dart';

import 'Widgets/main_page_storage/main_screens.dart';
import 'managers/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenManager.sharedData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppMessage.navigatorKey,
      debugShowCheckedModeBanner: false,
      darkTheme: themeDark,
      theme: themeLight,
      themeMode: ThemeMode.system,
      title: 'Mark',
      home: StreamBuilder<String?>(
        stream: TokenManager.tokenStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return FutureBuilder<Map<String, dynamic>>(
              future: TokenManager.getTokenUserRole(),
              builder: (context, tokenSnapshot) {
                if (tokenSnapshot.hasData && tokenSnapshot.data!.isNotEmpty) {
                  return MainScreens(decodedToken: tokenSnapshot.data);
                } else {
                  return const WelcomeScreen();
                }
              },
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
