import '../Constants.dart';
import '../Models/training_model.dart';
import '../Server/server_response.dart';
import '../Server/server_service.dart';

const urlApi = url;
String? token;

class TrainingProvider {
  Future<ServerResponse> getTraining(int? id) async {
    var url = 'training/getTraining';

    var server = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<TrainingResponseModel> responseModels = (serverResponse.result
                as List<dynamic>)
            .map((item) =>
                TrainingResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting user by member ${server.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> updateTraining(TrainingRequestModel model) async {
    var url = 'training/updateTraining';

    var server = await ServerService().executePutRequest(url, model);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      serverResponse.result = "Training updated successfully";
    } else {
      serverResponse.error =
          "Error while updating training ${server.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> deleteTraining(int id) async {
    var url = 'training/deleteTraining/$id';

    var server = await ServerService().executeDeleteRequest(url);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      serverResponse.result = "Training deleted successfully";
    } else {
      serverResponse.error =
          "Error while deleting training ${server.reasonPhrase}";
    }
    return serverResponse;
  }
}
