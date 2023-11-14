import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:swimming_app_client/Models/register_model.dart';

import '../../Models/userRole_model.dart';

class SignupController extends GetxController {
  bool validate = false;
  String? errorMessage;
  late RegisterRequestModel requestModel = RegisterRequestModel();
  late RegisterResponseModel responseModel = RegisterResponseModel();
  final bool _isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var addressController = TextEditingController();
  var userRoleID = 0;
  UserRoleRequestModel? userRoleModel = UserRoleRequestModel();


  @override
  void dispose(){
    super.dispose();
  }

  @override
  void onInit() {
    emailController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    nameController = TextEditingController(text: '');
    surnameController = TextEditingController(text: '');
    addressController = TextEditingController(text: '');
    userRoleID = 0;
    super.onInit();
  }
}