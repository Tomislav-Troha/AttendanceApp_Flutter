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
  final TrainingDateProvider _trainingDateProvider = TrainingDateProvider();
  final AttendanceProvider _attendanceProvider = AttendanceProvider();

  late List<AttendanceResponseModel> _myAttendancesList;
  List<TrainingDateResponseModel>? _trainingDates;
  late Future<List<TrainingResponseModel>> _trainingsForEmployees;

  bool _showAttendances = false;
  bool _isCurrentDate = true;

  DateTime? _currentDate;

  List<AttendanceResponseModel>? _attendanceList;

  void _getAttendances() async {
    ServerResponse allMyAttendances = await _attendanceProvider.getAttendance();
    if (allMyAttendances.isSuccessful) {
      _myAttendancesList = allMyAttendances.result
          .cast<AttendanceResponseModel>() as List<AttendanceResponseModel>;
    } else {
      AppMessage.showErrorMessage(
          message: allMyAttendances.error.toString(), duration: 5);
    }
  }

  void _getTrainingDates() async {
    if (_isCurrentDate) {
      _currentDate = DateTime.now().toLocal();
      ServerResponse allTrainingDatesByUser =
          await _trainingDateProvider.getTrainingDate(_currentDate);
      if (allTrainingDatesByUser.isSuccessful) {
        _trainingDates =
            allTrainingDatesByUser.result.cast<TrainingDateResponseModel>();
      } else {
        AppMessage.showErrorMessage(
            message: allTrainingDatesByUser.error.toString(), duration: 5);
      }
    } else {
      _currentDate = null;
      ServerResponse allTrainingDatesByUser =
          await _trainingDateProvider.getTrainingDate(_currentDate);
      if (allTrainingDatesByUser.isSuccessful) {
        _trainingDates =
            allTrainingDatesByUser.result.cast<TrainingDateResponseModel>();
      } else {
        AppMessage.showErrorMessage(
            message: allTrainingDatesByUser.error.toString(), duration: 5);
      }
    }
  }

  @override
  void initState() {
    _getTrainingDates();

    _getAttendances();

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
                        Text(
                          "Submitted attendances",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    )),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _isCurrentDate
                            ? const Icon(Icons.check_box,
                                color: Colors.blueAccent)
                            : const Icon(Icons.check_box_outline_blank,
                                color: Colors.blueAccent),
                        const Text("Just today trainings"),
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
                  _isCurrentDate = !_isCurrentDate;
                  _getTrainingDates();
                });
              }
            })
          ],
          title: const Text("My attendances"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: FutureBuilder(
            future: _trainingDateProvider.getTrainingDate(_currentDate),
            builder: (context, future) {
              if (!future.hasData) {
                return const CircularProgressIndicator();
              } else if (future.data!.result.isEmpty) {
                return Text(
                  "You don't have incoming trainings",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
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
                            attendanceResponse: _myAttendancesList,
                            index: index,
                          ),
                        );
                      },
                      onLongPress: () {},
                      child: Visibility(
                        child: AttendanceInfo(
                          filteredList: list,
                          attendancesList: _myAttendancesList,
                          index: index,
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
