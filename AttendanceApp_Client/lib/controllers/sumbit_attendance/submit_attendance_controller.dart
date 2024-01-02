import 'package:flutter/cupertino.dart';
import 'package:swimming_app_client/models/attendance_model.dart';

import '../../models/user_model.dart';

class SubmitAttendanceController {
  late AttendanceRequestModel requestModel = AttendanceRequestModel();
  late AttendanceResponseModel responseModel = AttendanceResponseModel();

  var id_attendance = TextEditingController();
  var attDesc = TextEditingController();
  var type = TextEditingController();
  var trainingID = TextEditingController();
  var userID = TextEditingController();
  var trainingDateID = TextEditingController();

  void addMemberToRequestModel(AttendanceRequestModel requestModel) {
    requestModel.trainingDateModel!.userModelList!.add(
      UserRequestModel(
        userId: requestModel.userModel!.userId,
        addres: "",
        email: requestModel.userModel!.email,
        name: requestModel.userModel!.name,
        surname: requestModel.userModel!.surname,
        userRoleID: requestModel.userModel!.userRoleID,
      ),
    );
  }
}
