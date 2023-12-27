import 'package:flutter/material.dart';
import 'package:swimming_app_client/enums/current_tab.dart';
import 'package:swimming_app_client/screens/attendance_member/attendance_member_screen.dart';

import '../../enums/user_roles.dart';
import '../../managers/token_manager.dart';
import '../../responsive.dart';
import '../../screens/add_training_date/add_training_date_screen.dart';
import '../../screens/attendance_employee/attendance_employee_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/pageStorageHome/profile_home/profile_home.dart';
import '../../stats/my_stats.dart';
import '../components/background.dart';
import '../custom_dialog.dart';

class MainScreens extends StatefulWidget {
  const MainScreens({super.key, required this.decodedToken});

  final Map<String, dynamic>? decodedToken;

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  final PageStorageBucket _bucket = PageStorageBucket();
  final IconData _icon = Icons.add;
  Widget _currentScreen = const AttendanceMember();
  bool _isAdmin = false;
  bool _buttonStatsEnabled = true;
  int _currentTab = 0;

  void _getScreenByRole() {
    if (widget.decodedToken!["UserRoleId"] == UserRoles.Member) {
      _currentScreen = const AttendanceMember();
      _isAdmin = false;
    } else if (widget.decodedToken!["UserRoleId"] == UserRoles.Employee ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Admin ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Moderator) {
      _currentScreen = const AttendanceEmployee(
        newTrainingDate: [],
      );
      _isAdmin = true;
    }
  }

  _openAddNewAttendanceOverlay() async {
    final result = await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (builder) => const AddTrainingDateScreen(),
    );

    if (result != null) {
      if ((widget.decodedToken!["UserRoleId"] == UserRoles.Employee ||
              widget.decodedToken!["UserRoleId"] == UserRoles.Admin ||
              widget.decodedToken!["UserRoleId"] == UserRoles.Moderator) &&
          _currentTab == CurrentTab.attendance) {
        setState(() {
          _currentScreen = AttendanceEmployee(
            newTrainingDate: result,
          );
        });
      }
    }
  }

  void _canUserAddNewAttendance() {
    if (_isAdmin) {
      _openAddNewAttendanceOverlay();
      setState(() {
        _buttonStatsEnabled = true;
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
        _buttonStatsEnabled = true;
        _currentScreen = const AttendanceMember();
        _currentTab = CurrentTab.attendance;
      });
    } else if (widget.decodedToken!["UserRoleId"] == UserRoles.Employee ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Admin ||
        widget.decodedToken!["UserRoleId"] == UserRoles.Moderator) {
      setState(() {
        _buttonStatsEnabled = true;
        _currentScreen = const AttendanceEmployee(
          newTrainingDate: [],
        );
        _currentTab = CurrentTab.attendance;
      });
    }
  }

  void _myStatsScreen() {
    if (_buttonStatsEnabled) {
      setState(() {
        _buttonStatsEnabled = false;
        _currentScreen = const MyStats();
        _currentTab = CurrentTab.myStats;
      });
    }
  }

  void _profileScreen() {
    setState(() {
      _currentScreen = const Profile();
      _currentTab = CurrentTab.profile;
      _buttonStatsEnabled = true;
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
              color: _currentTab == currentTabEnum
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary,
            ),
            Text(
              labelText,
              style: TextStyle(
                color: _currentTab == currentTabEnum
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSecondaryContainer,
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
              key: PageStorageKey(_currentTab),
              bucket: _bucket,
              child: _currentScreen,
            ),
            floatingActionButton: Visibility(
              child: FloatingActionButton(
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                onPressed: _canUserAddNewAttendance,
                child: Icon(
                  _icon,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).colorScheme.onSecondary,
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
