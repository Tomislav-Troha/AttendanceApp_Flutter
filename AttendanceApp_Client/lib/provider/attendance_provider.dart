import 'package:swimming_app_client/Models/attendance_model.dart';

import '../constants.dart';
import '../server_helper/server_response.dart';
import '../server_helper/server_service.dart';

const urlApi = url;
String? token;

class AttendanceProvider {
  Future<ServerResponse> getAttendance() async {
    var url = 'attendance/getAttendance';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<AttendanceResponseModel> responseModels = (serverResponse.result
                as List<dynamic>)
            .map((item) =>
                AttendanceResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting attendance ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getAttendanceAll(int? userID) async {
    var url = userID == null
        ? 'attendance/getAttendanceAll'
        : 'attendance/getAttendanceAll/$userID';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<AttendanceResponseModel> responseModels = (serverResponse.result
                as List<dynamic>)
            .map((item) =>
                AttendanceResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error =
          "Error while getting attendance ${response.reasonPhrase}";
    }

    return serverResponse;
  }

  Future<ServerResponse> addAttendance(AttendanceRequestModel model) async {
    var url = 'attendance/addAttendance';

    var server = await ServerService().executePostRequest(url, model);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      serverResponse.result =
          AttendanceResponseModel.fromJson(serverResponse.result);
    } else {
      serverResponse.error =
          "Error while inserting attendance ${server.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> addAttendanceNotSubmitted(
      AttendanceRequestModel model) async {
    var url = 'attendance/addAttendanceNotSubmitted';

    var server = await ServerService().executePostRequest(url, model);
    var serverResponse = ServerResponse(server);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<AttendanceResponseModel> responseModels = (serverResponse.result
                as List<dynamic>)
            .map((item) =>
                AttendanceResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      } else {
        serverResponse.result =
            AttendanceResponseModel.fromJson(serverResponse.result);
      }
    } else {
      serverResponse.error =
          "Error while getting attendance ${server.reasonPhrase}";
    }
    return serverResponse;
  }
}
