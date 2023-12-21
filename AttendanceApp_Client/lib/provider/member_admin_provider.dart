import '../constants.dart';
import '../models/user_model.dart';
import '../server_helper/server_response.dart';
import '../server_helper/server_service.dart';

const urlApi = url;
String? token;

class MemberAdminProvider {
  Future<ServerResponse> deleteUserMember(int id) async {
    var url = 'user/deleteUser/$id';

    var server = await ServerService().executeDeleteRequest(url);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      serverResponse.result = "User deleted successfully";
    } else {
      serverResponse.error = "Error while deleting user ${server.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getUserByMember() async {
    var url = 'user/getUserByMember';

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
}
