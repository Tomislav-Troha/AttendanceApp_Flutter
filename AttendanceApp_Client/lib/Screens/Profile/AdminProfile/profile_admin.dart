import 'package:flutter/material.dart';
import 'package:swimming_app_client/Screens/Profile/Employees/employees_admin.dart';
import 'package:swimming_app_client/Screens/Profile/Members/members_admin.dart';
import 'package:swimming_app_client/Screens/Profile/SetUserRole/set_user_role.dart';
import 'package:swimming_app_client/Screens/Profile/Training/training_admin.dart';

import '../../../Constants.dart';
import '../../../Widgets/screen_navigator.dart';

class ProfileAdmin extends StatefulWidget {
  @override
  _ProfileAdmin createState() => _ProfileAdmin();
}

class _ProfileAdmin extends State<ProfileAdmin> {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin"),
          automaticallyImplyLeading: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return SetUserRole();
                  },
                ));
              },
              child: const Text(
                "Register user",
                textScaleFactor: 1.3,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              child: const Text(
                "Members",
                textScaleFactor: 1.3,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return MemberAdmin();
                  },
                ));
              },
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              child: const Text(
                "Employees",
                textScaleFactor: 1.3,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return EmployeeAdmin();
                  },
                ));
              },
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              child: const Text(
                "Trainings",
                textScaleFactor: 1.3,
              ),
              onPressed: () {
                ScreenNavigator.navigateToScreen(context, TrainingAdmin());
              },
            ),
          ],
        ),
      ),
    );
  }
}
