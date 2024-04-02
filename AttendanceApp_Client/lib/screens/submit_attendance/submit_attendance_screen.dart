import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swimming_app_client/constants.dart';
import 'package:swimming_app_client/controllers/sumbit_attendance/submit_attendance_controller.dart';
import 'package:swimming_app_client/enums/attendance_description.dart';
import 'package:swimming_app_client/widgets/sumbit_attendance/submit_attendance_info.dart';

import '../../managers/token_manager.dart';
import '../../models/attendance_model.dart';
import '../../models/trainingDate_model.dart';
import '../../provider/attendance_provider.dart';
import '../../provider/training_date_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/training_time_utils.dart';

class SubmitAttendanceScreen extends StatefulWidget {
  const SubmitAttendanceScreen({
    super.key,
    required this.trainingDateResponse,
    this.attendanceResponse,
  });

  final TrainingDateResponseModel trainingDateResponse;
  final List<AttendanceResponseModel>? attendanceResponse;

  @override
  State<SubmitAttendanceScreen> createState() => _SubmitAttendance();
}

class _SubmitAttendance extends State<SubmitAttendanceScreen> {
  late final TrainingDateProvider _trainingDateProvider =
      TrainingDateProvider();
  List<AttendanceResponseModel>? _attendances;

  late Future<ServerResponse> _trainingDatesFuture;

  late TrainingDateResponseModel trainingDateResponseModel =
      widget.trainingDateResponse;

  final AttendanceProvider _attendanceProvider = AttendanceProvider();

  final SubmitAttendanceController _controller = SubmitAttendanceController();

  late bool _isInTime = false;
  late bool _isEarly = false;
  final bool _userIsLateForAttendance = false;
  late bool _isAttendanceCompleted = false;

  String _lateDays = "";
  String _lateHours = "";
  String _lateMinutes = "";

  String _earlyHours = "";

  late StreamController<Map<String, int>> _timeStreamController;
  late Map<String, int> _lateTime = {'days': 0, 'hours': 0, 'minutes': 0};
  late Timer _timer;

  void _getAttendanceInfo() async {
    Map<String, dynamic> token = await TokenManager.getTokenUserRole();

    ServerResponse getAttendanceByUser =
        await _attendanceProvider.getAttendanceAll(int.parse(token["UserID"]));
    if (getAttendanceByUser.isSuccessful) {
      _attendances = getAttendanceByUser.result.cast<AttendanceResponseModel>();

      for (var element in _attendances!) {
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
  }

  void _submitAttendance() async {
    if (_isInTime) {
      _controller.requestModel.attDesc = _userIsLateForAttendance
          ? AttendanceDescription.AcceptedWithLate
          : AttendanceDescription.Accepted;
      _controller.requestModel.type = _userIsLateForAttendance
          ? "Late: $_lateDays days, $_lateHours hours and $_lateMinutes minutes"
          : "On time";
      _controller.requestModel.trainingModel?.iD_training =
          widget.trainingDateResponse.trainingModel?.ID_training;
      _controller.requestModel.userModel?.userId =
          widget.trainingDateResponse.userModel?.userId;
      _controller.requestModel.trainingDateModel?.iD_TrainingDate =
          widget.trainingDateResponse.iD_TrainingDate;
      _controller.addMemberToRequestModel(_controller.requestModel);

      final response =
          await _attendanceProvider.addAttendance(_controller.requestModel);
      if (response.isSuccessful) {
        _isAttendanceCompleted = true;

        if (!mounted) return;
        AppMessage.showSuccessMessage(
            message: "Attendance submitted", context: context);
      } else {
        AppMessage.showErrorMessage(message: "Not in time");
      }
    }
  }

  void _validateTrainingTime() {
    bool isTrainingIsProgress = TrainingTimeUtils.isTrainingInProgress(
      widget.trainingDateResponse.dates!.toLocal(),
      TimeOfDay.fromDateTime(widget.trainingDateResponse.timeFrom!.toLocal()),
      TimeOfDay.fromDateTime(widget.trainingDateResponse.timeTo!.toLocal()),
    );

    if (!isTrainingIsProgress) {
      _lateTime = TrainingTimeUtils.calculateLateTime(
        widget.trainingDateResponse.dates!.toLocal(),
        TimeOfDay.fromDateTime(
          widget.trainingDateResponse.timeTo!.toLocal(),
        ),
      );

      _isEarly = _lateTime.values.every((value) => value == 0);

      if (_isEarly) {
        Duration? waitTime = TrainingTimeUtils.calculateWaitTime(
            widget.trainingDateResponse.dates!.toLocal(),
            widget.trainingDateResponse.timeFrom!);
        if (waitTime != null) {
          String startsIn =
              TrainingTimeUtils.calculateTrainingStartsIn(waitTime);
          _earlyHours = "Training starts in $startsIn";
        }
      } else {
        _timeStreamController.add(_lateTime);
      }
    } else {
      _isInTime = true;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      _validateTrainingTime();
    });
  }

  @override
  void initState() {
    super.initState();
    _timeStreamController = StreamController<Map<String, int>>();
    _getAttendanceInfo();
    _validateTrainingTime();
    _startTimer();
    _trainingDatesFuture = _trainingDateProvider.getTrainingDate(null);
  }

  @override
  void dispose() {
    _timeStreamController.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Attendance"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder(
          future: _trainingDatesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  SubmitAttendanceInfo(
                    trainingDateResponseModel: trainingDateResponseModel,
                  ),
                  StreamBuilder<Map<String, int>>(
                    stream: _timeStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (!_isAttendanceCompleted) {
                          Map<String, int> lateTime = snapshot.data!;
                          _lateDays = lateTime['days'].toString();
                          _lateHours = lateTime['hours'].toString();
                          _lateMinutes = lateTime['minutes'].toString();

                          return Text(
                            "Late: $_lateDays days, $_lateHours hours and $_lateMinutes minutes",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.redAccent),
                          );
                        }
                      }
                      return Visibility(
                        visible: _isInTime && !_isAttendanceCompleted,
                        replacement: Container(
                          padding: const EdgeInsets.all(12),
                          child: _isEarly && !_isAttendanceCompleted
                              ? Text(
                                  _earlyHours,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                )
                              : Text(
                                  _isAttendanceCompleted
                                      ? "Training completed"
                                      : "Late: $_lateDays days, $_lateHours hours and $_lateMinutes minutes",
                                  style: !_isAttendanceCompleted
                                      ? Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.redAccent,
                                          )
                                      : Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: _submitAttendance,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Submit attendance",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const Icon(
                                  Icons.check_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
