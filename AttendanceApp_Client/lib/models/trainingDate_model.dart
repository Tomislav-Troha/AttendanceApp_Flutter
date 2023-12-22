import 'package:swimming_app_client/models/training_model.dart';
import 'package:swimming_app_client/models/userRole_model.dart';
import 'package:swimming_app_client/models/user_model.dart';

class TrainingDateResponseModel {
  final int? iD_TrainingDate;
  final DateTime? dates;
  final DateTime? timeFrom;
  final DateTime? timeTo;
  final int? trainingID;
  final int? userID;
  final UserResponseModel? userModel;
  final TrainingResponseModel? trainingModel;
  final UserRoleResponseModel? userRoleModel;

  TrainingDateResponseModel({
    this.iD_TrainingDate,
    this.dates,
    this.timeFrom,
    this.timeTo,
    this.trainingID,
    this.userID,
    this.userModel,
    this.trainingModel,
    this.userRoleModel,
  });

  factory TrainingDateResponseModel.fromJson(Map<String, dynamic> json) {
    return TrainingDateResponseModel(
      iD_TrainingDate: json["iD_TrainingDate"],
      dates: json["dates"] == null ? null : DateTime.parse(json["dates"]),
      timeFrom:
          json["timeFrom"] == null ? null : DateTime.parse(json["timeFrom"]),
      timeTo: json["timeTo"] == null ? null : DateTime.parse(json["timeTo"]),
      trainingID: json["trainingID"],
      userID: json["userID"],
      userModel: json["userModel"] == null
          ? null
          : UserResponseModel?.fromJson(
              Map<String, dynamic>.from(json["userModel"])),
      trainingModel: json["trainingModel"] == null
          ? null
          : TrainingResponseModel?.fromJson(
              Map<String, dynamic>.from(json["trainingModel"])),
      userRoleModel: json["userRoleModel"] == null
          ? null
          : UserRoleResponseModel?.fromJson(
              Map<String, dynamic>.from(json["userRoleModel"])),
    );
  }
}

class TrainingDateRequestModel {
  int? iD_TrainingDate = 0;
  late DateTime? dates = DateTime.now();
  late DateTime? timeFrom = DateTime.now();
  late DateTime? timeTo = DateTime.now();
  int? trainingID = 0;
  int? userID = 0;
  UserRequestModel? userModel = UserRequestModel();
  TrainingRequestModel? trainingModel = TrainingRequestModel();
  UserRoleRequestModel? userRoleModel = UserRoleRequestModel();
  List<UserRequestModel>? userModelList = <UserRequestModel>[];

  TrainingDateRequestModel(
      {this.iD_TrainingDate = 0,
      dates,
      timeFrom,
      timeTo,
      this.trainingID = 0,
      this.userID = 0})
      : dates = dates == null ? DateTime.now() : null,
        timeFrom = timeFrom == null ? DateTime.now() : null,
        timeTo = timeTo == null ? DateTime.now() : null;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'iD_TrainingDate': iD_TrainingDate!,
      'dates': dates!.toIso8601String(),
      'timeFrom': timeFrom!.toIso8601String(),
      'timeTo': timeTo!.toIso8601String(),
      'trainingID': trainingID!,
      'userID': userID!,
      'userModel': userModel,
      'trainingModel': trainingModel,
      'userRoleModel': userRoleModel,
      'userModelList': userModelList?.map((e) => e.toJson()).toList()
    };

    return map;
  }
}
