import '../models/contract_model.dart';
import '../models/contract_type_model.dart';
import '../models/job_role_model.dart';
import '../models/salary_package_type_model.dart';
import '../server_helper/server_response.dart';
import '../server_helper/server_service.dart';

class ContractProvider {
  Future<ServerResponse> getContractsByUserId(int userId) async {
    var url = 'contract/getContract/$userId';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<ContractResponseModel> responseModels = (serverResponse.result
                as List<dynamic>)
            .map((item) =>
                ContractResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      } else {
        serverResponse.result =
            ContractResponseModel.fromJson(serverResponse.result);
      }
    } else {
      serverResponse.error =
          "Error while getting contract by user ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getContractType() async {
    var url = 'contractType/getContractTypes';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<ContractTypeResponseModel> responseModels =
            (serverResponse.result as List<dynamic>)
                .map((item) => ContractTypeResponseModel.fromJson(
                    item as Map<String, dynamic>))
                .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting contract types ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getSalaryPackageTypes() async {
    var url = 'salaryPackageType/getSalaryPackageType';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<SalaryPackageTypeResponseModel> responseModels =
            (serverResponse.result as List<dynamic>)
                .map((item) => SalaryPackageTypeResponseModel.fromJson(
                    item as Map<String, dynamic>))
                .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting salary package types ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getJobRoles() async {
    var url = 'jobRole/getJobRoles';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<JobRoleResponseModel> responseModels =
            (serverResponse.result as List<dynamic>)
                .map((item) =>
                    JobRoleResponseModel.fromJson(item as Map<String, dynamic>))
                .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting job role types ${response.reasonPhrase}";
    }
    return serverResponse;
  }
}
