import 'package:flutter/material.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/member_admin_provider.dart';
import 'package:swimming_app_client/Server/server_response.dart';
import 'package:swimming_app_client/enums/user_roles.dart';

import '../Enums/attendance_description.dart';
import '../Managers/token_manager.dart';
import '../Models/attendance_model.dart';
import '../Provider/attendance_provider.dart';
import '../Widgets/app_message.dart';

class MyStats extends StatefulWidget {
  const MyStats({super.key});

  @override
  State<StatefulWidget> createState() => _MyStats();
}

class _MyStats extends State<MyStats> {
  late AttendanceProvider attendanceProvider = AttendanceProvider();
  late MemberAdminProvider memberAdminProvider = MemberAdminProvider();
  List<AttendanceResponseModel> attendances = [];
  List<AttendanceResponseModel> allAttendances = [];
  List<UserResponseModel> users = [];
  int acceptedCount = 0;
  int notAcceptedCount = 0;
  int totalCount = 0;
  double acceptanceRate = 0;
  double greenBarWidth = 0;
  double redBarWidth = 0;

  late bool isAdmin = false;

  Map<String, dynamic>? token;

  void initializeUserModel() async {
    ServerResponse getAttendanceByUser =
        await attendanceProvider.getAttendance();

    ServerResponse user = await memberAdminProvider.getUserByMember();
    if (user.isSuccessful) {
      users = user.result.cast<UserResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: user.error);
    }

    setState(() {
      attendances = getAttendanceByUser.result.cast<AttendanceResponseModel>();

      if (!isAdmin) {
        for (var attendance in attendances) {
          if (attendance.attDesc == AttendanceDescription.Accepted) {
            acceptedCount++;
          } else {
            notAcceptedCount++;
          }
        }
        // Calculate percentage of accepted attendance
        totalCount = acceptedCount + notAcceptedCount;
        acceptanceRate = (totalCount == 0) ? 0 : (acceptedCount / totalCount);

        // Calculate size of green and red graph bars
        greenBarWidth = acceptanceRate * 100.0;
        redBarWidth = 100.0 - greenBarWidth;
      }
    });
  }

  void initializeAllAttendances() async {
    ServerResponse getAttendance =
        await attendanceProvider.getAttendanceAll(null);
    if (getAttendance.isSuccessful) {
      setState(() {
        allAttendances = getAttendance.result.cast<AttendanceResponseModel>();
      });
    } else {
      AppMessage.showErrorMessage(message: getAttendance.error);
    }
  }

  @override
  initState() {
    token = TokenManager().getTokenUserRole();

    if (token!["UserRoleId"] == UserRoles.Admin ||
        token!["UserRoleId"] == UserRoles.Moderator ||
        token!["UserRoleId"] == UserRoles.Employee) {
      isAdmin = true;
    }

    initializeUserModel();
    initializeAllAttendances();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Statistika"),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isAdmin) ...[
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        token!["FirstLastName"][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          token!["FirstLastName"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Broj dolazaka: $acceptedCount',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Broj neopravdanih: $notAcceptedCount',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Broj zabilježenih dolazaka',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      width: greenBarWidth,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Neopravdani dolasci',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      width: redBarWidth,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
              if (isAdmin) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AttendanceExpansionTile(
                        key: PageStorageKey<UserResponseModel>(users[index]),
                        user: users[index],
                        allAttendances: allAttendances,
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceExpansionTile extends StatefulWidget {
  final UserResponseModel user;
  final List<AttendanceResponseModel> allAttendances;

  const AttendanceExpansionTile({
    Key? key,
    required this.user,
    required this.allAttendances,
  }) : super(key: key);

  @override
  _AttendanceExpansionTileState createState() =>
      _AttendanceExpansionTileState();
}

class _AttendanceExpansionTileState extends State<AttendanceExpansionTile> {
  int acceptedCount = 0;
  int notAcceptedCount = 0;

  @override
  Widget build(BuildContext context) {
    for (var attendance in widget.allAttendances) {
      if (attendance.userModel!.userId == widget.user.userId) {
        if (attendance.attDesc == AttendanceDescription.Accepted) {
          acceptedCount++;
        } else {
          notAcceptedCount++;
        }
      }
    }

    return ExpansionTile(
      title: Text(
        widget.user.name!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ukupno potvrđenih dolazaka: $acceptedCount',
                  style: const TextStyle(fontSize: 14.0, color: Colors.green),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Ukupno neopravdanih dolazaka: $notAcceptedCount',
                  style: const TextStyle(fontSize: 14.0, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
