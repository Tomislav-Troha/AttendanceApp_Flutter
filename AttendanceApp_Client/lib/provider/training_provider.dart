import '../cache_manager/cache_manager.dart';
import '../constants.dart';
import '../models/training_model.dart';
import '../server_helper/server_response.dart';
import '../server_helper/server_service.dart';

const urlApi = url;
String? token;

class TrainingProvider {
  var cacheManager = CacheManager<TrainingResponseModel>(
    fromJson: (json) => TrainingResponseModel.fromJson(json),
    toJson: (training) => training.toJson(),
    getIdFromItem: (training) => training.ID_training!,
  );

  Future<ServerResponse> getTraining(int? id) async {
    // Fetch all trainings from cache if id is null
    if (id == null) {
      List<TrainingResponseModel> cachedTrainings =
          await cacheManager.getCachedItems();
      if (cachedTrainings.isNotEmpty) {
        return ServerResponse.success(cachedTrainings);
      }
    } else {
      // Try fetching a specific training from cache
      var cachedTraining = cacheManager.getItemFromCache(id);
      if (cachedTraining != null) {
        return ServerResponse.success(cachedTraining);
      }
    }

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

        // Cache the trainings
        await cacheManager.cacheItems(responseModels);

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting training: ${server.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> updateTraining(TrainingRequestModel model) async {
    var url = 'training/updateTraining';

    var server = await ServerService().executePutRequest(url, model);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      // cacheManager.removeItemFromCache(model.iD_training!);

      serverResponse.result =
          TrainingResponseModel.fromJson(serverResponse.result);

      await cacheManager.cacheItems([serverResponse.result]);

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
