import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:swimming_app_client/models/attendance_model.dart';

class SubmitAttendanceController extends GetxController {
  late AttendanceRequestModel requestModel = AttendanceRequestModel();
  late AttendanceResponseModel responseModel = AttendanceResponseModel();

  var id_attendance = TextEditingController();
  var attDesc = TextEditingController();
  var type = TextEditingController();
  var trainingID = TextEditingController();
  var userID = TextEditingController();
  var trainingDateID = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onInit() {
    id_attendance = TextEditingController(text: "");
    attDesc = TextEditingController(text: "");
    type = TextEditingController(text: "");
    trainingID = TextEditingController(text: "");
    userID = TextEditingController(text: "");
    trainingDateID = TextEditingController(text: "");

    super.onInit();
  }
}
