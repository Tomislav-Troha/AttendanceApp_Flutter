import 'package:flutter/material.dart';
import 'package:swimming_app_client/Constants.dart';
import 'package:swimming_app_client/Screens/Welcome/welcome_screen.dart';
import 'package:swimming_app_client/Widgets/app_message.dart';

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
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
    );
  }
}
