import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:swimming_app_client/Models/attendance_model.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/attendance_provider.dart';
import 'package:swimming_app_client/Server/server_response.dart';
import 'package:swimming_app_client/constants.dart';
import 'package:swimming_app_client/enums/attendance_description.dart';

import '../../Models/trainingDate_model.dart';
import '../../Provider/training_date_provider.dart';
import '../../Widgets/app_message.dart';
import '../../Widgets/attendance_status.dart';
import '../../Widgets/training_time_utils.dart';
import '../../controllers/sumbit_attendance/submit_attendance_controller.dart';

class SubmitAttendance extends StatefulWidget {
  const SubmitAttendance(
      {super.key,
      required this.trainingDateResponse,
      this.attendanceResponse,
      required this.index});

  final List<TrainingDateResponseModel> trainingDateResponse;
  final List<AttendanceResponseModel>? attendanceResponse;
  final int index;

  @override
  State<SubmitAttendance> createState() => _SubmitAttendance();
}

class _SubmitAttendance extends State<SubmitAttendance> {
  late TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  List<TrainingDateResponseModel>? trainingDates;
  List<AttendanceResponseModel>? attendances;

  late TrainingDateResponseModel trainingDateResponseModel =
      widget.trainingDateResponse[widget.index];

  late AttendanceProvider attendanceProvider = AttendanceProvider();

  SubmitAttendanceController controller = SubmitAttendanceController();

  late bool _isInTime = false;
  late bool _userIsLateForAttendance = false;
  late bool _isAttendanceCompleted = false;

  late final lateTime;
  String lateDays = "";
  String lateHours = "";
  String lateMinutes = "";

  void initialize() async {
    ServerResponse getAttendanceByUser =
        await attendanceProvider.getAttendance();
    if (getAttendanceByUser.isSuccessful) {
      attendances = getAttendanceByUser.result.cast<AttendanceResponseModel>();

      for (var element in attendances!) {
        if (element.trainingDateModel!.iD_TrainingDate ==
            widget.trainingDateResponse[widget.index].iD_TrainingDate) {
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

  @override
  void initState() {
    initialize();

    if (TrainingTimeUtils.isTrainingInProgress(
        widget.trainingDateResponse[widget.index].dates!.toLocal(),
        TimeOfDay.fromDateTime(
            widget.trainingDateResponse[widget.index].timeFrom!.toLocal()),
        TimeOfDay.fromDateTime(
            widget.trainingDateResponse[widget.index].timeTo!.toLocal()))) {
      _isInTime = true;
    } else {
      _isInTime = false;
    }

    lateTime = TrainingTimeUtils.calculateLateTime(
        widget.trainingDateResponse[widget.index].dates!.toLocal(),
        TimeOfDay.fromDateTime(
            widget.trainingDateResponse[widget.index].timeFrom!.toLocal()),
        TimeOfDay.fromDateTime(
            widget.trainingDateResponse[widget.index].timeTo!.toLocal()));

    if (lateTime != null) {
      lateDays = lateTime['days'].toString();
      lateHours = lateTime['hours'].toString();
      lateMinutes = lateTime['minutes'].toString();
    }

    super.initState();
  }

  void addAttendanceNotChecked() {
    controller.requestModel.attDesc = AttendanceDescription.NotAccepted;
    controller.requestModel.type =
        "Kašnjenje: $lateHours sati i $lateMinutes minuta";

    controller.requestModel.trainingModel?.iD_training =
        widget.trainingDateResponse[widget.index].trainingModel?.ID_training;
    controller.requestModel.userModel?.userId =
        widget.trainingDateResponse[widget.index].userModel?.userId;
    controller.requestModel.trainingDateModel?.iD_TrainingDate =
        widget.trainingDateResponse[widget.index].iD_TrainingDate;
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
    controller.requestModel.trainingDateModel?.userModelList = userList;

    attendanceProvider
        .addAttendance(controller.requestModel)
        .then((value) => {_isAttendanceCompleted = true})
        .catchError((error) {
      AppMessage.showErrorMessage(message: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime formattedDates =
        widget.trainingDateResponse[widget.index].dates!.toLocal();
    String formattedDatesString =
        formattedDates.toIso8601String().substring(0, 10);

    DateTime timeFrom =
        widget.trainingDateResponse[widget.index].timeFrom!.toLocal();
    DateTime timeTo =
        widget.trainingDateResponse[widget.index].timeTo!.toLocal();

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Submit attendance"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: FutureBuilder(
            future: trainingDateProvider.getTrainingDate(null),
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
                              widget.trainingDateResponse[widget.index]
                                  .trainingModel!.trainingType!,
                              textScaleFactor: 1.6,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Text(
                              formattedDatesString,
                              textScaleFactor: 1.4,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Text(
                              "${timeFrom.toLocal().hour}:${timeFrom.toLocal().minute} - ${timeTo.toLocal().hour}:${timeTo.toLocal().minute}",
                              textScaleFactor: 1.4,
                            ))
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
                                      transitionType:
                                          TransitionType.BOTTOM_TO_TOP,
                                      selectedTextColor: Colors.black,
                                      borderRadius: 60,
                                      text: "Potvrdi dolazak",
                                      textStyle: const TextStyle(
                                          fontFamily: 'Fredoka',
                                          fontSize: 30,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w300),
                                      onPress: () {
                                        if (_isInTime) {
                                          if (_userIsLateForAttendance) {
                                            controller.requestModel.attDesc =
                                                AttendanceDescription
                                                    .AcceptedWithLate;
                                            controller.requestModel.type =
                                                "Kašnjenje: $lateHours sati i $lateMinutes minuta";
                                          } else {
                                            controller.requestModel.attDesc =
                                                AttendanceDescription.Accepted;
                                            controller.requestModel.type =
                                                "Na vrijeme";
                                          }
                                          controller.requestModel.trainingModel
                                                  ?.iD_training =
                                              widget
                                                  .trainingDateResponse[
                                                      widget.index]
                                                  .trainingModel
                                                  ?.ID_training;
                                          controller.requestModel.userModel
                                                  ?.userId =
                                              widget
                                                  .trainingDateResponse[
                                                      widget.index]
                                                  .userModel
                                                  ?.userId;
                                          controller
                                                  .requestModel
                                                  .trainingDateModel
                                                  ?.iD_TrainingDate =
                                              widget
                                                  .trainingDateResponse[
                                                      widget.index]
                                                  .iD_TrainingDate;
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
                                          controller
                                              .requestModel
                                              .trainingDateModel
                                              ?.userModelList = userList;

                                          attendanceProvider
                                              .addAttendance(
                                                  controller.requestModel)
                                              .then((value) => {
                                                    _isAttendanceCompleted =
                                                        true
                                                  })
                                              .catchError((error) {
                                            AppMessage.showErrorMessage(
                                                message: error.toString());
                                          }).whenComplete(() => Timer(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    setState(() {
                                                      _isAttendanceCompleted =
                                                          true;
                                                    });
                                                  }));
                                        } else {
                                          AppMessage.showErrorMessage(
                                              message: "Not in time");
                                        }
                                      },
                                    ),
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Visibility(
                          child: Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  !_isAttendanceCompleted
                                      ? AttendanceStatusWidget(
                                          index: widget.index,
                                          attendList: widget.attendanceResponse,
                                          list: widget.trainingDateResponse,
                                          width: 200,
                                          height: 50,
                                          fontSize: 20,
                                        )
                                      : const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.check,
                                              size: 100,
                                              color: Colors.green,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Dolazak uspiješno zabilježen",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                  // else ...{
                                  //   Column(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: <Widget>[
                                  //       Text(
                                  //         widget.attendanceResponse!.any((element) => element.trainingDateModel?.iD_TrainingDate == widget.trainingDateResponse.iD_TrainingDate) ? "Dolazak je već potvrđen" : "Dolazak nije potvrđen",
                                  //         style: const TextStyle(
                                  //           color: Colors.red,
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 18,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(height: 10),
                                  //       Text(
                                  //         "Kašnjenje: $lateDays dana $lateHours sati i $lateMinutes minuta",
                                  //         style: const TextStyle(
                                  //           color: Colors.red,
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 18,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // }
                                ],
                              )),
                        )
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
