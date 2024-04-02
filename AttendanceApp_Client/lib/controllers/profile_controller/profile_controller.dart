import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/change_password_model.dart';

class ProfileController extends GetxController {
  ChangePasswordRequestModel changePasswordRequestModel =
      ChangePasswordRequestModel();
  ChangePasswordResponseModel changePasswordResponseModel =
      ChangePasswordResponseModel();

  var changePasswordEmail = TextEditingController();
  var newPassword = TextEditingController();

  String? apiErrors;

  @override
  void onInit() {
    changePasswordEmail = TextEditingController(text: "");
    newPassword = TextEditingController(text: "");
    super.onInit();
  }

  void clearApiErrorMessage() {
    apiErrors = null;
  }
}
