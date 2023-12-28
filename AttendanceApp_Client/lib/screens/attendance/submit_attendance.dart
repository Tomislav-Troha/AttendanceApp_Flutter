import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/constants.dart';
import 'package:swimming_app_client/controllers/sumbit_attendance/submit_attendance_controller.dart';
import 'package:swimming_app_client/enums/attendance_description.dart';

import '../../models/attendance_model.dart';
import '../../models/trainingDate_model.dart';
import '../../models/user_model.dart';
import '../../provider/attendance_provider.dart';
import '../../provider/training_date_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/training_time_utils.dart';

class SubmitAttendance extends StatefulWidget {
  const SubmitAttendance(
      {super.key, required this.trainingDateResponse, this.attendanceResponse});

  final TrainingDateResponseModel trainingDateResponse;
  final List<AttendanceResponseModel>? attendanceResponse;

  @override
  State<SubmitAttendance> createState() => _SubmitAttendance();
}

class _SubmitAttendance extends State<SubmitAttendance> {
  late TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  List<TrainingDateResponseModel>? trainingDates;
  List<AttendanceResponseModel>? attendances;

  late Future<ServerResponse> _trainingDatesFuture;

  late TrainingDateResponseModel trainingDateResponseModel =
      widget.trainingDateResponse;

  final AttendanceProvider _attendanceProvider = AttendanceProvider();

  final SubmitAttendanceController _controller = SubmitAttendanceController();

  late bool _isInTime = false;
  final bool _userIsLateForAttendance = false;
  late bool _isAttendanceCompleted = false;

  late final _lateTime;
  String lateDays = "";
  String lateHours = "";
  String lateMinutes = "";

  void _getAttendanceInfo() async {
    ServerResponse getAttendanceByUser =
        await _attendanceProvider.getAttendance();
    if (getAttendanceByUser.isSuccessful) {
      attendances = getAttendanceByUser.result.cast<AttendanceResponseModel>();

      for (var element in attendances!) {
        if (element.trainingDateModel!.iD_TrainingDate ==
            widget.trainingDateResponse.iD_TrainingDate) {
          if (element.attDesc == AttendanceDescription.Accepted ||
              element.attDesc == AttendanceDescription.AcceptedWithLate) {
            _isAttendanceCompleted = true;
          }
        }
      }
    } else {
      AppMessage.showErrorMessage(message: getAttendanceByUser.error);
    }

    //get all training dates by user
    ServerResponse allTrainingDatesByUser =
        await trainingDateProvider.getTrainingDate(null);
    if (allTrainingDatesByUser.isSuccessful) {
      trainingDates =
          allTrainingDatesByUser.result.cast<TrainingDateResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: allTrainingDatesByUser.error);
    }
  }

  void _submitAttendance() async {
    if (_isInTime) {
      if (_userIsLateForAttendance) {
        _controller.requestModel.attDesc =
            AttendanceDescription.AcceptedWithLate;
        _controller.requestModel.type =
            "Late: $lateHours hours and $lateMinutes minutes";
      } else {
        _controller.requestModel.attDesc = AttendanceDescription.Accepted;
        _controller.requestModel.type = "On time";
      }
      _controller.requestModel.trainingModel?.iD_training =
          widget.trainingDateResponse.trainingModel?.ID_training;
      _controller.requestModel.userModel?.userId =
          widget.trainingDateResponse.userModel?.userId;
      _controller.requestModel.trainingDateModel?.iD_TrainingDate =
          widget.trainingDateResponse.iD_TrainingDate;
      List<UserRequestModel> userList = [];
      userList.add(UserRequestModel(
          surname: "",
          password: "",
          name: "",
          email: "",
          addres: "",
          salt: "",
          userId: 0,
          username: "",
          userRoleID: 0));
      _controller.requestModel.trainingDateModel?.userModelList = userList;

      final response =
          await _attendanceProvider.addAttendance(_controller.requestModel);
      if (response.isSuccessful) {
        _isAttendanceCompleted = true;
        AppMessage.showErrorMessage(message: "Attendance submitted");
      } else {
        AppMessage.showErrorMessage(message: "Not in time");
      }
    }
  }

  void _calculateTimeOfTraining() {
    if (TrainingTimeUtils.isTrainingInProgress(
        widget.trainingDateResponse.dates!.toLocal(),
        TimeOfDay.fromDateTime(widget.trainingDateResponse.timeFrom!.toLocal()),
        TimeOfDay.fromDateTime(
            widget.trainingDateResponse.timeTo!.toLocal()))) {
      _isInTime = true;
    } else {
      _isInTime = false;
    }

    _lateTime = TrainingTimeUtils.calculateLateTime(
        widget.trainingDateResponse.dates!.toLocal(),
        TimeOfDay.fromDateTime(widget.trainingDateResponse.timeFrom!.toLocal()),
        TimeOfDay.fromDateTime(widget.trainingDateResponse.timeTo!.toLocal()));

    if (_lateTime != null) {
      lateDays = _lateTime['days'].toString();
      lateHours = _lateTime['hours'].toString();
      lateMinutes = _lateTime['minutes'].toString();
    }
  }

  @override
  void initState() {
    super.initState();

    _getAttendanceInfo();
    _calculateTimeOfTraining();

    _trainingDatesFuture = trainingDateProvider.getTrainingDate(null);
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeFrom = widget.trainingDateResponse.timeFrom!.toLocal();
    DateTime timeTo = widget.trainingDateResponse.timeTo!.toLocal();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit attendance"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder(
          future: _trainingDatesFuture,
          builder: (context, future) {
            if (!future.hasData) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Text(
                            widget.trainingDateResponse.trainingModel!
                                .trainingType!,
                            textScaleFactor: 1.6,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ))
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          DateFormat("dd.MM.yyyy").format(
                              widget.trainingDateResponse.dates!.toLocal()),
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          "${timeFrom.toLocal().hour}:${timeFrom.toLocal().minute} - ${timeTo.toLocal().hour}:${timeTo.toLocal().minute}",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Visibility(
                          visible: _isInTime,
                          child: _isAttendanceCompleted
                              ? Container()
                              : AnimatedButton(
                                  selectedBackgroundColor:
                                      Colors.lightBlueAccent,
                                  width: 280,
                                  height: 85,
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.blue,
                                  borderWidth: 4,
                                  transitionType: TransitionType.BOTTOM_TO_TOP,
                                  selectedTextColor: Colors.black,
                                  borderRadius: 60,
                                  text: "Submit attendance",
                                  textStyle: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  onPress: _submitAttendance,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
