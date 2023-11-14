import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Managers/token_manager.dart';
import '../../Provider/user_provider.dart';
import '../../Widget-Helpers/app_message.dart';
import '../PageStorageHome/main_screen.dart';
import 'Welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppMessage.navigatorKey,
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1), () {
          return Provider.of<UserProvider>(context, listen: false).checkForToken();
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/logo.svg", width: 600, height: 600),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // Obtain UserProvider instance
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          // Check if the user is logged in
          if (userProvider.isUserLoggedIn) {
            // Retrieve decoded token
            TokenManager tokenManager = TokenManager();
            Map<String, dynamic> tokenData = tokenManager.getTokenUserRole();
            return HomeScreen(decodedToken: tokenData);  // Your HomeScreen widget
          } else {
            return const WelcomeScreen();  // Your WelcomeScreen widget
          }
        },
      ),
    );
  }
}
