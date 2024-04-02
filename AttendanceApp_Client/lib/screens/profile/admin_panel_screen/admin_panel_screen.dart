import 'package:flutter/material.dart';
import 'package:swimming_app_client/screens/profile/Employees/employees_admin.dart';
import 'package:swimming_app_client/screens/profile/Members/members_admin.dart';
import 'package:swimming_app_client/screens/profile/Training/training_admin.dart';

import '../../../constants.dart';
import '../SetUserRole/set_user_role.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget setButtons(String text, Widget screen) {
      return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return screen;
              },
            ),
          );
        },
        child: Text(
          text,
          textScaleFactor: 1.3,
        ),
      );
    }

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
            setButtons(
              "Register user",
              const SetUserRole(),
            ),
            const SizedBox(height: defaultPadding),
            setButtons(
              "Members",
              const MemberAdmin(),
            ),
            const SizedBox(height: defaultPadding),
            setButtons(
              "Employees",
              EmployeeAdmin(),
            ),
            const SizedBox(height: defaultPadding),
            setButtons(
              "Trainings",
              const TrainingAdmin(),
            ),
          ],
        ),
      ),
    );
  }
}
