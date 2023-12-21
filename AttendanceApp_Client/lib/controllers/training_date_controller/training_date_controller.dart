import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/models/trainingDate_model.dart';

import '../../models/user_model.dart';

class TrainingDateController {
  late TrainingDateRequestModel requestModel = TrainingDateRequestModel();
  late TrainingDateResponseModel responseModel = TrainingDateResponseModel();

  var trainingID = TextEditingController();
  var date = TextEditingController();
  var timeFrom = TextEditingController();
  var timeTo = TextEditingController();
  var members = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      date.text = DateFormat("dd-MM-yyyy").format(picked);
      selectedDate = DateTime(picked.year, picked.month, picked.day);
    }
  }

  Future<DateTime?> selectTime(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      return DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      // timeFrom.text = timeFormat.format(selectedTime);
    }
    return null;
  }

  void addUserToRequestModel(UserResponseModel user) {
    members.text = user.userId.toString();
    requestModel.userModelList?.add(UserRequestModel(
      userId: user.userId,
      addres: "",
      email: user.email,
      name: user.name,
      surname: user.surname,
      userRoleID: user.userRoleID,
    ));
  }

  String? validateTrainingDateInputs({
    required String trainingID,
    required String date,
    required String timeFrom,
    required String timeTo,
  }) {
    if (trainingID.isEmpty ||
        date.isEmpty ||
        timeFrom.isEmpty ||
        timeTo.isEmpty) {
      return "Sva polja su obavezna";
    }
    return null;
  }

  DateTime? parseDate(String dateText) {
    if (dateText.isEmpty) return null;
    return DateFormat('dd-MM-yyyy').parse(dateText);
  }

  DateTime parseTime(String timeText) {
    final parts = timeText.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  void clearControllers() {
    members.clear();
    trainingID.clear();
    date.clear();
    timeFrom.clear();
    timeTo.clear();
  }
}
