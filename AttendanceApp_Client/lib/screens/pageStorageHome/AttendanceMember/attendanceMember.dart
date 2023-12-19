import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/Models/attendance_model.dart';
import 'package:swimming_app_client/Models/trainingDate_model.dart';
import 'package:swimming_app_client/Provider/attendance_provider.dart';
import 'package:swimming_app_client/Provider/training_date_provider.dart';
import 'package:swimming_app_client/Server/server_response.dart';

import '../../../Models/training_model.dart';
import '../../../Widgets/app_message.dart';
import '../../../Widgets/attendance_status.dart';
import '../../../Widgets/screen_navigator.dart';
import '../../attendance/submit_attendance.dart';

class AttendanceMember extends StatefulWidget {
  const AttendanceMember({super.key});

  @override
  State<AttendanceMember> createState() => _AttendanceMember();
}

class _AttendanceMember extends State<AttendanceMember> {
  late TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  late AttendanceProvider attendanceProvider = AttendanceProvider();

  late List<AttendanceResponseModel> myAttendances;
  List<TrainingDateResponseModel>? trainingDates;
  late Future<List<TrainingResponseModel>> trainingsForEmployees;

  List<AttendanceResponseModel>? attendList = [];

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
      myAttendances = allMyAttendances.result.cast<AttendanceResponseModel>();
    } else {
      AppMessage.showErrorMessage(
          message: allMyAttendances.error.toString(), duration: 5);
    }
    for (var att in myAttendances) {
      attendList?.add(att);
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
                              attendanceResponse: attendList,
                              index: index,
                            ));
                      },
                      onLongPress: () {},
                      child: Visibility(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${list[index].trainingModel!.trainingType} ${DateFormat('dd-MM-yyyy').format(list[index].dates!.toLocal())}",
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${DateFormat('HH:mm').format(list[index].timeFrom!.toLocal())} - ${DateFormat('HH:mm').format(list[index].timeTo!.toLocal())}",
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                AttendanceStatusWidget(
                                  index: index,
                                  attendList: attendList,
                                  list: list,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
