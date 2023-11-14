import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swimming_app_client/Constants.dart';
import 'package:swimming_app_client/Provider/attendance_provider.dart';
import 'package:swimming_app_client/Provider/employee_admin_provider.dart';
import 'package:swimming_app_client/Provider/member_admin_provider.dart';
import 'package:swimming_app_client/Provider/training_date_provider.dart';
import 'package:swimming_app_client/Provider/training_provider.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'Managers/token_manager.dart';
import 'Screens/Welcome/splash_screen.dart';

void main() {
  runApp(const MyApp());
  TokenManager.sharedData();
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider<TrainingDateProvider>(
        create: (_) => TrainingDateProvider(),
      ),
      ChangeNotifierProvider<TrainingProvider>(
        create: (_) => TrainingProvider(),
      ),
      ChangeNotifierProvider<AttendanceProvider>(
        create: (_) => AttendanceProvider(),
      ),
      ChangeNotifierProvider<EmployeeAdminProvider>(
        create: (_) => EmployeeAdminProvider(),
      ),
      ChangeNotifierProvider<MemberAdminProvider>(
        create: (_) => MemberAdminProvider(),
      ),
      ChangeNotifierProvider<MemberAdminProvider>(
        create: (_) => MemberAdminProvider(),
      ),
      ],
    child: MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Attendance app',
      theme: ThemeData(
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

    ),
    );
  }
}