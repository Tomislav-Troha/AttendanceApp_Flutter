class TrainingResponseModel {
  int? ID_training;
  String? code;
  String? trainingType;

  TrainingResponseModel({this.ID_training, this.code, this.trainingType});

  factory TrainingResponseModel.fromJson(Map<String, dynamic> json){
    return TrainingResponseModel(
        ID_training: json["iD_training"], code: json["code"], trainingType: json["trainingType"]
    );
  }
}

class TrainingRequestModel {
  int? iD_training = 0;
  String? code = "";
  String? trainingType = "";

  TrainingRequestModel({
    this.iD_training = 0,
    this.code = "",
    this.trainingType = ""
  });

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'iD_training': iD_training,
      'code': code!.trim(),
      'trainingType': trainingType!.trim(),
    };

    return map;
  }
}