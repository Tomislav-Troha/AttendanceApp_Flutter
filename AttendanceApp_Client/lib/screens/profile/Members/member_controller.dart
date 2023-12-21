import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Models/user_model.dart';

class MemberAdminController extends GetxController {
  late UserRequestModel requestModel = UserRequestModel();
  late UserResponseModel responseModel = UserResponseModel();

  var name = TextEditingController();
  var surname = TextEditingController();
  var adress = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onInit() {
    name = TextEditingController(text: "");
    surname = TextEditingController(text: "");
    adress = TextEditingController(text: "");

    super.onInit();
  }
}
