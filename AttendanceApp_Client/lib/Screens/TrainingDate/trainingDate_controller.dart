import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/Models/trainingDate_model.dart';
import 'package:swimming_app_client/Widget-Helpers/app_message.dart';

import '../../Models/user_model.dart';


class TrainingDateController extends GetxController{

late TrainingDateRequestModel requestModel = TrainingDateRequestModel();
late TrainingDateResponseModel responseModel = TrainingDateResponseModel();

var trainingID = TextEditingController();
var date = TextEditingController();
var timeFrom = TextEditingController();
var timeTo = TextEditingController();
var members = TextEditingController();

@override
void dispose(){
  super.dispose();
}

@override
void onInit(){
  trainingID = TextEditingController(text: "");
  date = TextEditingController(text: "");
  timeFrom = TextEditingController(text: "");
  timeTo = TextEditingController(text: "");
  members = TextEditingController(text:  "");
  super.onInit();
}

DateTime selectedDate = DateTime.now();
Future<void> selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101)
  );
  if(picked != null && picked != DateTime.now()){
    date.text = DateFormat("dd-MM-yyyy").format(picked);
    selectedDate = DateTime(picked.year, picked.month, picked.day);
  }
}

Future<void> selectTimeFrom(BuildContext context) async {
  final timeFormat = DateFormat.Hm();
  final now = DateTime.now();
  final initialTime = timeFrom.text.isNotEmpty
      ? timeFormat.parse(timeFrom.text).toLocal()
      : DateTime(now.hour, now.minute).toLocal();

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
    final selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    final selectedDateNow = DateTime(now.year, now.month, now.day);
    if (selectedTime.isBefore(now) && selectedDate == selectedDateNow) {
      // show error message to user
      AppMessage.showErrorMessage(message: "Vrijeme dolaska ne može biti manje od trenutnog vremena");
    } else {
      timeFrom.text = timeFormat.format(selectedTime);
    }
  }
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

Future<void> selectTimeTo(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:  TimeOfDay.now(),
      builder: (context, child) {
          return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!
    );
  },
  );

  if(picked != null && picked != TimeOfDay.now()){
    timeTo.text = picked.hour.toString() + ":" + picked.minute.toString();
  }
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

DateTime parseDate(String dateText) {
  return DateFormat('dd-MM-yyyy').parse(dateText);
}

DateTime parseTime(String timeText) {
  final parts = timeText.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
}


void clearControllers() {
  members.clear();
  trainingID.clear();
  date.clear();
  timeFrom.clear();
  timeTo.clear();
}




}