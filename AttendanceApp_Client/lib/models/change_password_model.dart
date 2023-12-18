class ChangePasswordResponseModel {
  List? errors = [];
  bool? success;

  ChangePasswordResponseModel({this.errors, this.success});

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json){
    return ChangePasswordResponseModel(
        errors: json["errors"], success: json["success"]
    );
  }
}

class ChangePasswordRequestModel {
  String? email;
  String? password;

  ChangePasswordRequestModel({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'email': email!.trim(),
      'password': password!.trim(),
    };
    return map;
  }


}