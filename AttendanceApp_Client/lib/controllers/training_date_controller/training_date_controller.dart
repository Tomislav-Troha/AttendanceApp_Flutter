import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/models/trainingDate_model.dart';
import 'package:swimming_app_client/models/training_model.dart';
import 'package:swimming_app_client/models/userRole_model.dart';

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

  void addMembersToRequestModel(UserResponseModel user) {
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

  TrainingDateResponseModel handleAddNewTrainingDate(
      TrainingDateRequestModel model) {
    TrainingDateResponseModel newTrainingDate = TrainingDateResponseModel(
      iD_TrainingDate: model.iD_TrainingDate,
      dates: model.dates,
      timeFrom: model.timeFrom,
      timeTo: model.timeTo,
      userID: model.userID,
      trainingID: model.trainingID,
      trainingModel: TrainingResponseModel(
        ID_training: model.trainingModel!.iD_training,
        code: model.trainingModel!.code,
        trainingType: model.trainingModel!.trainingType,
      ),
      userModel: UserResponseModel(
        userId: model.userModel!.userId,
        addres: model.userModel!.addres,
        email: model.userModel!.email,
        name: model.userModel!.name,
        profileImage: model.userModel!.profileImage,
        surname: model.userModel!.surname,
        username: model.userModel!.username,
        userRoleID: model.userModel!.userRoleID,
        userRoleModel: UserRoleResponseModel(
          roleDesc: model.userModel!.userRoleModel.roleDesc,
          roleID: model.userModel!.userRoleModel.roleID,
          roleName: model.userModel!.userRoleModel.roleName,
        ),
      ),
      userRoleModel: UserRoleResponseModel(
        roleDesc: model.userModel!.userRoleModel.roleDesc,
        roleID: model.userModel!.userRoleModel.roleID,
        roleName: model.userModel!.userRoleModel.roleName,
      ),
    );
    return newTrainingDate;
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

  DateTime? getCombinedDateTime(DateTime? selectedTimeFrom) {
    DateTime currentDate = DateTime.now();
    DateTime combinedDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      selectedTimeFrom!.hour,
      selectedTimeFrom.minute,
      selectedTimeFrom.second,
    );
    return combinedDateTime;
  }
}
