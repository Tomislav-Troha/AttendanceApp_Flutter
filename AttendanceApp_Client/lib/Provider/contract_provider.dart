import 'package:flutter/cupertino.dart';
import 'package:swimming_app_client/Models/contract_model.dart';
import 'package:swimming_app_client/Models/contract_type_model.dart';
import 'package:swimming_app_client/Models/job_role_model.dart';
import 'package:swimming_app_client/Models/salary_package_type_model.dart';

import '../Server/server_response.dart';
import '../Server/server_service.dart';

class ContractProvider extends ChangeNotifier{

  Future<ServerResponse> getContractsByUserId(int userId) async {
    var url = 'contract/getContract/$userId';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if(serverResponse.isSuccessful){
      if(serverResponse.result is List<dynamic>){
        List<ContractResponseModel> responseModels = (serverResponse.result as List<dynamic>)
            .map((item) => ContractResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error = "Error while getting contract by user ${response.reasonPhrase}";
    }
    return serverResponse;
  }


  Future<ServerResponse> getContractType() async {
    var url = 'contractType/getContractTypes';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if(serverResponse.isSuccessful){
      if(serverResponse.result is List<dynamic>){
        List<ContractTypeResponseModel> responseModels = (serverResponse.result as List<dynamic>)
            .map((item) => ContractTypeResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error = "Error while getting contract types ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getSalaryPackageTypes() async {
    var url = 'salaryPackageType/getSalaryPackageType';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if(serverResponse.isSuccessful){
      if(serverResponse.result is List<dynamic>){
        List<SalaryPackageTypeResponseModel> responseModels = (serverResponse.result as List<dynamic>)
            .map((item) => SalaryPackageTypeResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error = "Error while getting salary package types ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getJobRoles() async {
    var url = 'jobRole/getJobRoles';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if(serverResponse.isSuccessful){
      if(serverResponse.result is List<dynamic>){
        List<JobRoleResponseModel> responseModels = (serverResponse.result as List<dynamic>)
            .map((item) => JobRoleResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error = "Error while getting job role types ${response.reasonPhrase}";
    }
    return serverResponse;
  }

}