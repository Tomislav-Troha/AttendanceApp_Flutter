import 'package:swimming_app_client/Models/contract_model.dart';
import 'package:swimming_app_client/Server/server_response.dart';

import '../Constants.dart';
import '../Models/userRole_model.dart';
import '../Models/user_model.dart';
import '../Server/server_service.dart';

const urlApi = url;
String? token;

class UserRoleProvider {
  Future<ServerResponse> getUserRoleNotSet() async {
    var url = 'user/userRoleIsNull';

    var server = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<UserResponseModel> responseModels =
            (serverResponse.result as List<dynamic>)
                .map((item) =>
                    UserResponseModel.fromJson(item as Map<String, dynamic>))
                .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting user by member ${serverResponse.error}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getUserRoles() async {
    var url = 'user/getUserRoles';

    var server = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<UserRoleResponseModel> responseModels = (serverResponse.result
                as List<dynamic>)
            .map((item) =>
                UserRoleResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting userRoles ${serverResponse.error}";
    }
    return serverResponse;
  }

  Future<ServerResponse> addUserRole(
      ContractRequestModel model, int userId) async {
    var url = 'contract/addContract/$userId';

    var server = await ServerService().executePostRequest(url, model);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      serverResponse.result = "Contract added successfully";
    } else {
      serverResponse.error =
          "Error while adding contract ${server.reasonPhrase}";
    }
    return serverResponse;
  }
}
