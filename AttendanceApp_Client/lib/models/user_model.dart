import 'dart:convert';
import 'dart:typed_data';

import 'package:swimming_app_client/models/userRole_model.dart';

class UserResponseModel {
  int? userId;
  String? name;
  String? surname;
  String? email;
  String? username;
  String? addres;
  UserRoleResponseModel? userRoleModel;
  int? userRoleID;
  Uint8List? profileImage;
  UserResponseModel(
      {this.userId,
      this.name,
      this.surname,
      this.email,
      this.username,
      this.addres,
      this.userRoleModel,
      this.userRoleID,
      this.profileImage});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
        userId: json["userId"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        username: json["username"],
        addres: json["addres"],
        userRoleModel: json["userRoleModel"] == null
            ? null
            : UserRoleResponseModel.fromJson(
                Map<String, dynamic>.from(json["userRoleModel"])),
        userRoleID: json["userRoleID"],
        profileImage: json['profileImage'] != null
            ? const Base64Decoder().convert(json['profileImage'])
            : null);
  }
}

class UserRequestModel {
  int? userId = 0;
  String? name = "";
  String? surname = "";
  String? email = "";
  String? username = "";
  String? password = "";
  String? salt = "";
  String? addres = "";
  int? userRoleID = 0;
  final UserRoleRequestModel userRoleModel = UserRoleRequestModel();
  Uint8List? profileImage;

  UserRequestModel({
    this.userId = 0,
    this.name = "",
    this.surname = "",
    this.email = "",
    this.username = "",
    this.password = "",
    this.salt = "",
    this.addres = "",
    this.userRoleID = 0,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'userId': userId!,
      'name': name!.trim(),
      'surname': surname!.trim(),
      'email': email!.trim(),
      'username': username!.trim(),
      'password': password!.trim(),
      'salt': salt!.trim(),
      'addres': addres!.trim(),
      'userRoleID': userRoleID!,
      'userRoleModel': UserRoleRequestModel(),
      'profileImage': profileImage != null ? base64Encode(profileImage!) : ''
    };

    return map;
  }
}
