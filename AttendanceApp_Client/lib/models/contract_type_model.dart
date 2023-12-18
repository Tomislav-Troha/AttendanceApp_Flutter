class ContractTypeResponseModel {
  int? contractTypeID;
  String? contractTypeName;
  String? contractTypeDescription;

  ContractTypeResponseModel({
    this.contractTypeID,
    this.contractTypeName,
    this.contractTypeDescription,
  });

  factory ContractTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return ContractTypeResponseModel(
      contractTypeID: json['contractTypeID'],
      contractTypeName: json['contractTypeName'],
      contractTypeDescription: json['contractTypeDescription'],
    );
  }
}


class ContractTypeRequestModel {
  int? contractTypeID = 0;
  String? contractTypeName = "";
  String? contractTypeDescription = "";

  ContractTypeRequestModel({
    this.contractTypeID = 0,
    this.contractTypeName = "",
    this.contractTypeDescription = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'contractTypeID': contractTypeID,
      'contractTypeName': contractTypeName?.trim(),
      'contractTypeDescription': contractTypeDescription?.trim(),
    };
  }
}
