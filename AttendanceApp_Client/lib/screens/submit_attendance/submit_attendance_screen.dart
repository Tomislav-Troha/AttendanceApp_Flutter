import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/constants.dart';
import 'package:swimming_app_client/controllers/sumbit_attendance/submit_attendance_controller.dart';
import 'package:swimming_app_client/enums/attendance_description.dart';

import '../../models/attendance_model.dart';
import '../../models/trainingDate_model.dart';
import '../../provider/attendance_provider.dart';
import '../../provider/training_date_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/sumbit_attendance/build_info_text.dart';
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
  final bool _userIsLateForAttendance = false;
  late bool _isAttendanceCompleted = false;

  String _lateDays = "";
  String _lateHours = "";
  String _lateMinutes = "";

  late StreamController<Map<String, int>> _timeStreamController;
  late Map<String, int> _lateTime = {'days': 0, 'hours': 0, 'minutes': 0};
  late Timer _timer;

  void _getAttendanceInfo() async {
    ServerResponse getAttendanceByUser =
        await _attendanceProvider.getAttendance();
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
      if (_userIsLateForAttendance) {
        _controller.requestModel.attDesc =
            AttendanceDescription.AcceptedWithLate;
        _controller.requestModel.type =
            "Late: $_lateDays days, $_lateHours hours and $_lateMinutes minutes";
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

  void _calculateTimeOfTraining() {
    bool isInTime = TrainingTimeUtils.isTrainingInProgress(
      widget.trainingDateResponse.dates!.toLocal(),
      TimeOfDay.fromDateTime(widget.trainingDateResponse.timeFrom!.toLocal()),
      TimeOfDay.fromDateTime(widget.trainingDateResponse.timeTo!.toLocal()),
    );

    if (!isInTime) {
      _lateTime = TrainingTimeUtils.calculateLateTime(
        widget.trainingDateResponse.dates!.toLocal(),
        TimeOfDay.fromDateTime(widget.trainingDateResponse.timeFrom!.toLocal()),
        TimeOfDay.fromDateTime(widget.trainingDateResponse.timeTo!.toLocal()),
      );

      _timeStreamController.add(_lateTime);
    } else {
      _isInTime = true;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd.MM.yyyy").format(date);
  }

  String _formatTime(DateTime from, DateTime to) {
    return "${from.toLocal().hour}:${from.toLocal().minute.toString().padLeft(2, '0')} - ${to.toLocal().hour}:${to.toLocal().minute.toString().padLeft(2, '0')}";
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      _calculateTimeOfTraining();
    });
  }

  @override
  void initState() {
    super.initState();
    _timeStreamController = StreamController<Map<String, int>>();
    _getAttendanceInfo();
    _calculateTimeOfTraining();
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
    DateTime timeFrom = widget.trainingDateResponse.timeFrom!.toLocal();
    DateTime timeTo = widget.trainingDateResponse.timeTo!.toLocal();

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
                  InfoText(
                    context: context,
                    text: widget
                        .trainingDateResponse.trainingModel!.trainingType!,
                    scale: 1.6,
                  ),
                  InfoText(
                    context: context,
                    text: _formatDate(
                        widget.trainingDateResponse.dates!.toLocal()),
                    scale: 1.4,
                  ),
                  InfoText(
                    context: context,
                    text: _formatTime(timeFrom, timeTo),
                    scale: 1.4,
                  ),
                  StreamBuilder<Map<String, int>>(
                    stream: _timeStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, int> lateTime = snapshot.data!;
                        _lateDays = lateTime['days'].toString();
                        _lateHours = lateTime['hours'].toString();
                        _lateMinutes = lateTime['minutes'].toString();

                        return Text(
                          "Late: $_lateDays days, $_lateHours hours and $_lateMinutes minutes",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.redAccent),
                        );
                      }
                      return Visibility(
                        visible: _isInTime && !_isAttendanceCompleted,
                        replacement: Container(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Late: $_lateDays days, $_lateHours hours and $_lateMinutes minutes",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.redAccent),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: ElevatedButton(
                            onPressed: _submitAttendance,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Submit attendance",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
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
