import '../constants.dart';
import '../models/trainingDate_model.dart';
import '../server_helper/server_response.dart';
import '../server_helper/server_service.dart';

const urlApi = url;
String? token;

class TrainingDateProvider {
  Future<ServerResponse> getTrainingDate(DateTime? currentDate) async {
    var url = currentDate == null
        ? 'trainingDate/getTrainingDate'
        : 'trainingDate/getTrainingDate/$currentDate';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<TrainingDateResponseModel> responseModels =
            (serverResponse.result as List<dynamic>)
                .map((item) => TrainingDateResponseModel.fromJson(
                    item as Map<String, dynamic>))
                .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting training date ${serverResponse.error}";
    }
    return serverResponse;
  }

  Future<ServerResponse> deleteTrainingDate(int id) async {
    var url = 'trainingDate/deleteTrainingDate/$id';

    var response = await ServerService().executeDeleteRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      serverResponse.result = "Training Date deleted successfully";
    } else {
      if (serverResponse.error!.contains("error: 23503")) {
        serverResponse.error = "Training Date cannot be deleted";
      } else {
        serverResponse.error =
            "Error while deleting training date ${serverResponse.error}";
      }
    }
    return serverResponse;
  }

  Future<ServerResponse> getTrainingDateForEmployee(
      DateTime? currentDate) async {
    var url = currentDate == null
        ? 'trainingDate/getTrainingDateForEmployee'
        : 'trainingDate/getTrainingDateForEmployee/$currentDate';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<TrainingDateResponseModel> responseModels =
            (serverResponse.result as List<dynamic>)
                .map((item) => TrainingDateResponseModel.fromJson(
                    item as Map<String, dynamic>))
                .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting training date for employee ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> addTrainingDate(TrainingDateRequestModel model) async {
    var url = 'trainingDate/addTrainingDate';

    var response = await ServerService().executePostRequest(url, model);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      TrainingDateResponseModel responseModels =
          TrainingDateResponseModel.fromJson(serverResponse.result);
      serverResponse.result = responseModels;
    } else {
      serverResponse.error =
          "Error while adding training date ${serverResponse.error}";
    }
    return serverResponse;
  }
}
