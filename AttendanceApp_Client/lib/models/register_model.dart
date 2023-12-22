import 'package:swimming_app_client/models/userRole_model.dart';

class RegisterResponseModel {
  final List? errors;
  bool? success;

  RegisterResponseModel({this.errors, this.success});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
        errors: json["errors"], success: json["success"]);
  }
}

class RegisterRequestModel {
  String? name = "";
  String? surname = "";
  String? email = "";
  String? password = "";
  String? username = "";
  String? addres = "";
  int? userRoleID = 0;
  final UserRoleRequestModel? userRole = UserRoleRequestModel();

  RegisterRequestModel(
      {this.name = "",
      this.surname = "",
      this.email = "",
      this.password = "",
      this.username = "",
      this.addres = "",
      this.userRoleID = 0});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name!.trim(),
      'surname': surname!.trim(),
      'email': email!.trim(),
      'password': password!.trim(),
      'username': username!.trim(),
      'addres': addres!.trim(),
      'userRoleID': userRoleID,
      'userRole': userRole!
    };

    return map;
  }
}
