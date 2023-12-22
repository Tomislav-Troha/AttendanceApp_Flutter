import 'package:swimming_app_client/models/salary_package_type_model.dart';
import 'package:swimming_app_client/models/userRole_model.dart';
import 'package:swimming_app_client/models/user_model.dart';

import 'contract_type_model.dart';
import 'job_role_model.dart';

class ContractResponseModel {
  int? contractID;
  int? userID;
  int? userRoleID;
  int? contractTypeID;
  int? salaryPackageID;
  int? jobRoleID;
  DateTime? startDate;
  DateTime? expiryDate;
  final UserResponseModel? userModel;
  final UserRoleResponseModel? userRoleModel;
  final ContractTypeResponseModel? contractTypeModel;
  final SalaryPackageTypeResponseModel? salaryPackageTypeModel;
  final JobRoleResponseModel? jobRoleModel;

  ContractResponseModel(
      {this.contractID,
      this.userID,
      this.userRoleID,
      this.contractTypeID,
      this.salaryPackageID,
      this.jobRoleID,
      this.startDate,
      this.expiryDate,
      this.userModel,
      this.userRoleModel,
      this.contractTypeModel,
      this.salaryPackageTypeModel,
      this.jobRoleModel});

  factory ContractResponseModel.fromJson(Map<String, dynamic> json) {
    return ContractResponseModel(
      contractID: json['contractID'],
      userID: json['userID'],
      userRoleID: json['userRoleID'],
      contractTypeID: json['contractTypeID'],
      salaryPackageID: json['salaryPackageID'],
      jobRoleID: json['jobRoleID'],
      startDate: (json['startDate'] != null)
          ? DateTime.parse(json['startDate'])
          : null,
      expiryDate: (json['expiryDate'] != null)
          ? DateTime.parse(json['expiryDate'])
          : null,
      userModel: json["userModel"] == null
          ? null
          : UserResponseModel.fromJson(
              Map<String, dynamic>.from(json["userModel"])),
      userRoleModel: json["userRoleModel"] == null
          ? null
          : UserRoleResponseModel.fromJson(
              Map<String, dynamic>.from(json["userRoleModel"])),
      contractTypeModel: json["contractTypeModel"] == null
          ? null
          : ContractTypeResponseModel.fromJson(
              Map<String, dynamic>.from(json["contractTypeModel"])),
      salaryPackageTypeModel: json["salaryPackageTypeModel"] == null
          ? null
          : SalaryPackageTypeResponseModel.fromJson(
              Map<String, dynamic>.from(json["salaryPackageTypeModel"])),
      jobRoleModel: json["jobRoleModel"] == null
          ? null
          : JobRoleResponseModel.fromJson(
              Map<String, dynamic>.from(json["jobRoleModel"])),
    );
  }
}

// EmployeeContractRequestModel
class ContractRequestModel {
  int? contractID;
  int? userID;
  int? userRoleID;
  int? contractTypeID;
  int? salaryPackageID;
  int? jobRoleID;
  DateTime? startDate = DateTime.now();
  DateTime? expiryDate = DateTime.now();
  final UserRequestModel? userModel = UserRequestModel();
  final UserRoleRequestModel? userRoleModel = UserRoleRequestModel();
  final ContractTypeRequestModel? contractTypeModel =
      ContractTypeRequestModel();
  final SalaryPackageTypeRequestModel? salaryPackageTypeModel =
      SalaryPackageTypeRequestModel();
  final JobRoleRequestModel? jobRoleModel = JobRoleRequestModel();

  ContractRequestModel(
      {this.contractID = 0,
      this.userID = 0,
      this.userRoleID = 0,
      this.contractTypeID = 0,
      this.salaryPackageID = 0,
      this.jobRoleID = 0});

  Map<String, dynamic> toJson() {
    return {
      'contractID': contractID,
      'userID': userID,
      'userRoleID': userRoleID,
      'contractTypeID': contractTypeID,
      'salaryPackageID': salaryPackageID,
      'jobRoleID': jobRoleID,
      'startDate': startDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'userModel': userModel,
      'userRoleModel': userRoleModel,
      'contractTypeModel': contractTypeModel,
      'salaryPackageTypeModel': salaryPackageTypeModel,
      'jobRoleModel': jobRoleModel,
    };
  }
}
