

class UserRoleResponseModel {
  int? roleID;
  String? roleName;
  String? roleDesc;

  UserRoleResponseModel({this.roleID, this.roleName, this.roleDesc});

  factory UserRoleResponseModel.fromJson(Map<String, dynamic> json){
    return UserRoleResponseModel(
        roleID: json["roleId"], roleName: json["roleName"], roleDesc: json["roleDesc"]
    );
  }
}

class UserRoleRequestModel {
  int? roleID;
  String? roleName;
  String? roleDesc;


  UserRoleRequestModel({
    this.roleID = 0,
    this.roleName = "",
    this.roleDesc = ""
  });

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'roleID': roleID,
      'roleName': roleName!.trim(),
      'roleDesc': roleDesc!.trim()
    };

    return map;
  }


}