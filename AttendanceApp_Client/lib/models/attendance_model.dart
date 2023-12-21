import 'package:swimming_app_client/models/trainingDate_model.dart';
import 'package:swimming_app_client/models/training_model.dart';
import 'package:swimming_app_client/models/userRole_model.dart';
import 'package:swimming_app_client/models/user_model.dart';

class AttendanceResponseModel {
  final int? iD_attendance;
  final String? attDesc;
  final String? type;
  final int? trainingID;
  final int? userID;
  final int? trainingDateID;
  final TrainingResponseModel? trainingModel;
  final UserResponseModel? userModel;
  final TrainingDateResponseModel? trainingDateModel;
  final UserRoleResponseModel? userRoleModel;

  AttendanceResponseModel(
      {this.iD_attendance,
      this.attDesc,
      this.type,
      this.trainingID,
      this.userID,
      this.trainingDateID,
      this.trainingModel,
      this.userModel,
      this.trainingDateModel,
      this.userRoleModel});

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
        iD_attendance: json["iD_attendance"],
        attDesc: json["attDesc"],
        type: json["type"],
        trainingID: json["trainingID"],
        userID: json["userID"],
        trainingDateID: json["trainingDateID"],
        userModel: json["userModel"] == null
            ? null
            : UserResponseModel.fromJson(
                Map<String, dynamic>.from(json["userModel"])),
        trainingModel: json["trainingModel"] == null
            ? null
            : TrainingResponseModel.fromJson(
                Map<String, dynamic>.from(json["trainingModel"])),
        trainingDateModel: json["trainingDateModel"] == null
            ? null
            : TrainingDateResponseModel.fromJson(
                Map<String, dynamic>.from(json["trainingDateModel"])),
        userRoleModel: json["userRoleModel"] == null
            ? null
            : UserRoleResponseModel.fromJson(
                Map<String, dynamic>.from(json["userRoleModel"])));
  }
}

class AttendanceRequestModel {
  int? iD_attendance = 0;
  String? attDesc = "";
  String? type = "";
  int? trainingID = 0;
  int? userID = 0;
  int? trainingDateID = 0;
  final UserRequestModel? userModel = UserRequestModel();
  final TrainingRequestModel? trainingModel = TrainingRequestModel();
  final TrainingDateRequestModel? trainingDateModel =
      TrainingDateRequestModel();
  final UserRoleRequestModel? userRoleModel = UserRoleRequestModel();

  AttendanceRequestModel(
      {this.iD_attendance = 0,
      this.attDesc = "",
      this.type = "",
      this.trainingID = 0,
      this.userID = 0,
      this.trainingDateID = 0});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'ID_attendance': iD_attendance!,
      'attDesc': attDesc!.trim(),
      'type': type!.trim(),
      'trainingID': trainingID!,
      'userID': userID!,
      'trainingDateID': trainingDateID!,
      'trainingModel': trainingModel,
      'userModel': userModel,
      'trainingDateModel': trainingDateModel,
      'userRoleModel': userRoleModel
    };

    return map;
  }
}
