class JobRoleResponseModel {
  int? jobRoleID;
  String? jobRoleName;
  String? jobRoleDescription;

  JobRoleResponseModel({
    this.jobRoleID,
    this.jobRoleName,
    this.jobRoleDescription,
  });

  factory JobRoleResponseModel.fromJson(Map<String, dynamic> json) {
    return JobRoleResponseModel(
      jobRoleID: json['jobRoleID'],
      jobRoleName: json['jobRoleName'],
      jobRoleDescription: json['jobRoleDescription'],
    );
  }
}

class JobRoleRequestModel {
  int? jobRoleID = 0;
  String? jobRoleName = "";
  String? jobRoleDescription = "";

  JobRoleRequestModel({
    this.jobRoleID = 0,
    this.jobRoleName = "" ,
    this.jobRoleDescription = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'jobRoleID': jobRoleID,
      'jobRoleName': jobRoleName?.trim(),
      'jobRoleDescription': jobRoleDescription?.trim(),
    };
  }
}
