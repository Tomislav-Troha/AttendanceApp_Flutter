class SalaryPackageTypeResponseModel {
  int? salaryPackageID;
  String? salaryPackageName;
  String? salaryPackageDescription;

  SalaryPackageTypeResponseModel({
    this.salaryPackageID,
    this.salaryPackageName,
    this.salaryPackageDescription,
  });

  factory SalaryPackageTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return SalaryPackageTypeResponseModel(
      salaryPackageID: json['salaryPackageID'],
      salaryPackageName: json['salaryPackageName'],
      salaryPackageDescription: json['salaryPackageDescription'],
    );
  }
}

class SalaryPackageTypeRequestModel {
  int? salaryPackageID = 0;
  String? salaryPackageName = "";
  String? salaryPackageDescription = "";

  SalaryPackageTypeRequestModel({
    this.salaryPackageID = 0,
    this.salaryPackageName = "",
    this.salaryPackageDescription = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'salaryPackageID': salaryPackageID,
      'salaryPackageName': salaryPackageName?.trim(),
      'salaryPackageDescription': salaryPackageDescription?.trim(),
    };
  }
}
