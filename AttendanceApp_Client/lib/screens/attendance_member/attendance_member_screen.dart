import 'package:flutter/material.dart';
import 'package:swimming_app_client/widgets/attendance/attendance_info.dart';

import '../../models/attendance_model.dart';
import '../../models/trainingDate_model.dart';
import '../../models/training_model.dart';
import '../../provider/attendance_provider.dart';
import '../../provider/training_date_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/screen_navigator.dart';
import '../attendance/submit_attendance.dart';

class AttendanceMember extends StatefulWidget {
  const AttendanceMember({
    super.key,
  });

  @override
  State<AttendanceMember> createState() => _AttendanceMember();
}

class _AttendanceMember extends State<AttendanceMember> {
  late TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  late AttendanceProvider attendanceProvider = AttendanceProvider();

  late List<AttendanceResponseModel> myAttendancesList;
  List<TrainingDateResponseModel>? trainingDates;
  late Future<List<TrainingResponseModel>> trainingsForEmployees;

  bool isEmployee = false;
  bool isSubmitted = false;
  bool _showAttendances = false;
  bool isPressed = false;
  bool isCurrentDate = true;

  bool isAttendanceAddedLate = false;

  DateTime? currentDate;

  List<AttendanceResponseModel>? attendanceList;

  void initializeAttendanceList() async {
    ServerResponse allMyAttendances = await attendanceProvider.getAttendance();
    if (allMyAttendances.isSuccessful) {
      myAttendancesList = allMyAttendances.result
          .cast<AttendanceResponseModel>() as List<AttendanceResponseModel>;
    } else {
      AppMessage.showErrorMessage(
          message: allMyAttendances.error.toString(), duration: 5);
    }
  }

  void getTrainingDates() async {
    if (isCurrentDate) {
      currentDate = DateTime.now().toLocal();
      ServerResponse allTrainingDatesByUser =
          await trainingDateProvider.getTrainingDate(currentDate);
      if (allTrainingDatesByUser.isSuccessful) {
        trainingDates =
            allTrainingDatesByUser.result.cast<TrainingDateResponseModel>();
      } else {
        AppMessage.showErrorMessage(
            message: allTrainingDatesByUser.error.toString(), duration: 5);
      }
    } else {
      currentDate = null;
      ServerResponse allTrainingDatesByUser =
          await trainingDateProvider.getTrainingDate(currentDate);
      if (allTrainingDatesByUser.isSuccessful) {
        trainingDates =
            allTrainingDatesByUser.result.cast<TrainingDateResponseModel>();
      } else {
        AppMessage.showErrorMessage(
            message: allTrainingDatesByUser.error.toString(), duration: 5);
      }
    }
  }

  @override
  void initState() {
    getTrainingDates();

    initializeAttendanceList();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _showAttendances
                            ? const Icon(Icons.check_box,
                                color: Colors.blueAccent)
                            : const Icon(Icons.check_box_outline_blank,
                                color: Colors.blueAccent),
                        const Text("Zabilježeni dolasci"),
                      ],
                    )),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        isCurrentDate
                            ? const Icon(Icons.check_box,
                                color: Colors.blueAccent)
                            : const Icon(Icons.check_box_outline_blank,
                                color: Colors.blueAccent),
                        const Text("Samo današnji treninzi"),
                      ],
                    )),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                setState(() {
                  _showAttendances = !_showAttendances;
                });
              } else if (value == 1) {
                setState(() {
                  isCurrentDate = !isCurrentDate;
                  getTrainingDates();
                });
              }
            })
          ],
          title: const Text("Moji dolasci"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: FutureBuilder(
            future: trainingDateProvider.getTrainingDate(currentDate),
            builder: (context, future) {
              if (!future.hasData) {
                return const CircularProgressIndicator();
              } else if (future.data!.result.isEmpty) {
                return const Text("Nemaš nadolezećih termina");
              } else {
                List<TrainingDateResponseModel>? list =
                    future.data!.result.cast<TrainingDateResponseModel>();
                return ListView.builder(
                  itemCount: list!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ScreenNavigator.navigateToScreen(
                            context,
                            SubmitAttendance(
                              trainingDateResponse: list,
                              attendanceResponse: myAttendancesList,
                              index: index,
                            ));
                      },
                      onLongPress: () {},
                      child: Visibility(
                          child: AttendanceInfo(
                        filteredList: list,
                        attendancesList: myAttendancesList,
                        index: index,
                      )),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
