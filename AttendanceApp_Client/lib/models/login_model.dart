class LoginResponseModel {
  String? token;
  List? errors = [];
  bool? success;

  LoginResponseModel({this.errors, this.success, this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json){
    return LoginResponseModel(
        token: json["token"] ?? "", errors: json["errors"], success: json["success"]
    );
  }
}

class LoginRequestModel {
  String? email;
  String? username = "";
  String? password;
  String? sessionUuid = "";

  LoginRequestModel({
    this.email,
    this.username = "",
    this.password,
    this.sessionUuid = ""
  });

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'email': email!.trim(),
      'username': username!.trim(),
      'password': password!.trim(),
      'sessionUuid': sessionUuid!.trim()
    };

    return map;
  }


}