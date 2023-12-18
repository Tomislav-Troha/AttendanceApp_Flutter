import 'package:flutter/material.dart';
import 'package:swimming_app_client/Enums/EnumUserRoles.dart';
import 'package:swimming_app_client/Managers/token_manager.dart';
import 'package:swimming_app_client/Screens/Login/login_screen.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/AttendanceEmployee/attendanceEmployee.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/AttendanceMember/attendanceMember.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/ProfileHome/profile_home.dart';
import 'package:swimming_app_client/Stats/my_stats.dart';

import '../../Widgets/custom_dialog.dart';
import '../../responsive.dart';
import '../Components/background.dart';
import '../TrainingDate/add_trainingDate.dart';

class HomeScreen extends StatefulWidget {
  Map<String, dynamic>? decodedToken;
  HomeScreen({super.key, required this.decodedToken});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  IconData icon = Icons.add;
  Widget currentScreen = const AttendanceMember();
  bool _isAdmin = false;
  bool buttonStatsEnables = true;

  @override
  void initState() {
    if (widget.decodedToken!["UserRoleId"] == EnumUserRole.Member) {
      currentScreen = const AttendanceMember();
      _isAdmin = false;
    } else if (widget.decodedToken!["UserRoleId"] == EnumUserRole.Employee ||
        widget.decodedToken!["UserRoleId"] == EnumUserRole.Admin ||
        widget.decodedToken!["UserRoleId"] == EnumUserRole.Moderator) {
      currentScreen = const AttendanceEmployee();
      _isAdmin = true;
    }

    super.initState();
  }

  final PageStorageBucket bucket = PageStorageBucket();
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  if (_isAdmin) {
                    setState(() {
                      buttonStatsEnables = true;
                      currentScreen = AddTrainingDate();
                      currentTab = 2;
                      icon = currentTab == 2
                          ? Icons.access_alarms_rounded
                          : Icons.add;
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
                },
                child: Icon(icon),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              buttonStatsEnables = true;

                              if (widget.decodedToken!["UserRoleId"] ==
                                  EnumUserRole.Member) {
                                currentScreen = const AttendanceMember();
                                currentTab = 0;
                              } else if (widget.decodedToken!["UserRoleId"] ==
                                      EnumUserRole.Employee ||
                                  widget.decodedToken!["UserRoleId"] ==
                                      EnumUserRole.Admin ||
                                  widget.decodedToken!["UserRoleId"] ==
                                      EnumUserRole.Moderator) {
                                currentScreen = const AttendanceEmployee();
                                currentTab = 0;
                              }
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_chart,
                                color:
                                    currentTab == 0 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Mark',
                                style: TextStyle(
                                  color: currentTab == 0
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            if (buttonStatsEnables) {
                              setState(() {
                                buttonStatsEnables = false;
                                currentScreen = MyStats();
                                currentTab = 1;
                              });
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.query_stats,
                                color:
                                    currentTab == 1 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Statistics',
                                style: TextStyle(
                                  color: currentTab == 1
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = const Profile();
                              currentTab = 3;
                              buttonStatsEnables = true;
                              // icon = currentTab == 3 ? Icons.check : Icons.add;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle_outlined,
                                color:
                                    currentTab == 3 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: currentTab == 3
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            TokenManager.clearPrefs();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const LoginScreen();
                                },
                              ),
                            );
                          },
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.grey,
                              ),
                              Text(
                                'Log off',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        )
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
