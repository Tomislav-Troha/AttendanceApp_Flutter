import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:swimming_app_client/Models/change_password_model.dart';
import 'package:swimming_app_client/Models/login_model.dart';

class LoginController extends GetxController {

  bool validate = false;
  String? errorMessage;
  late LoginRequestModel requestModel = LoginRequestModel();
  late LoginResponseModel responseModel = LoginResponseModel();

  late ChangePasswordResponseModel changePasswordResponseModel = ChangePasswordResponseModel();
  late ChangePasswordRequestModel changePasswordRequestModel = ChangePasswordRequestModel();

  final bool _isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var changePasswordEmail = TextEditingController();
  var newPassword = TextEditingController();

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void onInit() {
    emailController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    newPassword = TextEditingController(text: '');
    super.onInit();
  }



}