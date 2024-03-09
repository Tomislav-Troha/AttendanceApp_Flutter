import 'package:flutter/material.dart';
import 'package:swimming_app_client/widgets/attendance/attendance_info.dart';
import 'package:swimming_app_client/widgets/drawer/drawer_main.dart';

import '../../models/attendance_model.dart';
import '../../models/trainingDate_model.dart';
import '../../provider/attendance_provider.dart';
import '../../provider/training_date_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/screen_navigator.dart';
import '../submit_attendance/submit_attendance_screen.dart';

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

  late Future<ServerResponse> _trainingDatesFuture;

  late List<AttendanceResponseModel> _myAttendancesList;

  List<TrainingDateResponseModel>? trainingList;

  DateTime? _currentDate;

  void _getAttendances() async {
    ServerResponse allMyAttendances =
        await _attendanceProvider.getAttendanceAll(null);
    if (allMyAttendances.isSuccessful) {
      _myAttendancesList = allMyAttendances.result
          .cast<AttendanceResponseModel>() as List<AttendanceResponseModel>;
    } else {
      AppMessage.showErrorMessage(
          message: allMyAttendances.error.toString(), duration: 5);
    }
  }

  void _navigateToAttendanceDetails(
      TrainingDateResponseModel trainingDateResponse) {
    ScreenNavigator.navigateToScreen(
      context,
      SubmitAttendanceScreen(
        trainingDateResponse: trainingDateResponse,
        attendanceResponse: _myAttendancesList,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAttendances();

    _trainingDatesFuture = _trainingDateProvider.getTrainingDate(_currentDate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My attendances"),
      ),
      drawer: DrawerMain(
        onSelectedScreen: (value) {},
      ),
      body: Center(
        child: FutureBuilder(
          future: _trainingDatesFuture,
          builder: (context, future) {
            if (!future.hasData) {
              return const CircularProgressIndicator();
            } else if (future.data?.result.isEmpty) {
              return Text(
                "You don't have incoming trainings",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            } else {
              trainingList =
                  future.data!.result.cast<TrainingDateResponseModel>();
              return ListView.builder(
                itemCount: trainingList!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToAttendanceDetails(trainingList![index]);
                    },
                    child: Visibility(
                      child: AttendanceInfo(
                        training: trainingList![index],
                        attendancesList: _myAttendancesList,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
