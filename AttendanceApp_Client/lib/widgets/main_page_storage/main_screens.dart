import 'package:flutter/material.dart';
import 'package:swimming_app_client/Managers/token_manager.dart';
import 'package:swimming_app_client/Screens/Login/login_screen.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/AttendanceEmployee/attendanceEmployee.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/AttendanceMember/attendanceMember.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/ProfileHome/profile_home.dart';
import 'package:swimming_app_client/Stats/my_stats.dart';
import 'package:swimming_app_client/enums/current_tab.dart';

import '../../enums/user_roles.dart';
import '../../responsive.dart';
import '../../screens/TrainingDate/add_trainingDate.dart';
import '../components/background.dart';
import '../custom_dialog.dart';

class MainScreens extends StatefulWidget {
  const MainScreens({super.key, required this.decodedToken});

  final Map<String, dynamic>? decodedToken;

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  final PageStorageBucket bucket = PageStorageBucket();

  IconData icon = Icons.add;
  Widget currentScreen = const AttendanceMember();
  bool _isAdmin = false;
  bool buttonStatsEnables = true;
  int currentTab = 0;

  void _getScreenByRole() {
    if (widget.decodedToken!["UserRoleId"] == UserRoles.Member) {
      currentScreen = const AttendanceMember();
      _isAdmin = false;
    } else if (widget.decodedToken!["UserRoleId"] == UserRoles.Employee ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Admin ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Moderator) {
      currentScreen = const AttendanceEmployee();
      _isAdmin = true;
    }
  }

  void _canUserAddNewAttendance() {
    if (_isAdmin) {
      setState(() {
        buttonStatsEnables = true;
        currentScreen = const AddTrainingDate();
        currentTab = 2;
        icon = currentTab == 2 ? Icons.access_alarms_rounded : Icons.add;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "",
            message: "You have no right for this option!",
            children: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _attendanceScreen() {
    if (widget.decodedToken!["UserRoleId"] == UserRoles.Member) {
      setState(() {
        buttonStatsEnables = true;
        currentScreen = const AttendanceMember();
        currentTab = CurrentTab.attendance;
      });
    } else if (widget.decodedToken!["UserRoleId"] == UserRoles.Employee ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Admin ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Moderator) {
      setState(() {
        buttonStatsEnables = true;
        currentScreen = const AttendanceEmployee();
        currentTab = CurrentTab.attendance;
      });
    }
  }

  void _myStatsScreen() {
    if (buttonStatsEnables) {
      setState(() {
        buttonStatsEnables = false;
        currentScreen = const MyStats();
        currentTab = CurrentTab.myStats;
      });
    }
  }

  void _profileScreen() {
    setState(() {
      currentScreen = const Profile();
      currentTab = CurrentTab.profile;
      buttonStatsEnables = true;
    });
  }

  void _logOut() {
    TokenManager.clearPrefs();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _getScreenByRole();
  }

  @override
  Widget build(BuildContext context) {
    Widget getBottomScreenButtons(void Function() onPressed, IconData icon,
        String labelText, int? currentTabEnum) {
      return MaterialButton(
        minWidth: 40,
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: currentTab == currentTabEnum
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            Text(
              labelText,
              style: TextStyle(
                color: currentTab == currentTabEnum
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondary,
              ),
            )
          ],
        ),
      );
    }

    return Background(
      resizeToAvoidBottomInset: false,
      child: Responsive(
        mobile: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: PageStorage(
              key: PageStorageKey(currentTab),
              bucket: bucket,
              child: currentScreen,
            ),
            floatingActionButton: Visibility(
              child: FloatingActionButton(
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                onPressed: _canUserAddNewAttendance,
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).colorScheme.primary,
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getBottomScreenButtons(
                          _attendanceScreen,
                          Icons.add_chart,
                          "Mark",
                          CurrentTab.attendance,
                        ),
                        getBottomScreenButtons(
                          _myStatsScreen,
                          Icons.query_stats,
                          "Statistics",
                          CurrentTab.myStats,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getBottomScreenButtons(
                          _profileScreen,
                          Icons.account_circle_outlined,
                          "Profile",
                          CurrentTab.profile,
                        ),
                        getBottomScreenButtons(
                          _logOut,
                          Icons.logout,
                          "Log out",
                          null,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        desktop: const Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
