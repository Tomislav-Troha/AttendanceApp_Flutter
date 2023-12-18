import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swimming_app_client/Screens/Welcome/welcome_screen.dart';
import 'package:swimming_app_client/Widgets/app_message.dart';
import 'package:swimming_app_client/constants.dart';

import 'Managers/token_manager.dart';

void main() {
  runApp(const MyApp());
  TokenManager.sharedData();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppMessage.navigatorKey,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Attendance app',
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          surface: kPrimaryLightColor,
        ),
        scaffoldBackgroundColor: kPrimaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.poppins().copyWith(
              fontSize: 16,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            fixedSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(
            color: Colors.black, // default color
            letterSpacing: 1.3,
          ),
        ),
      ),
    );
  }
}
