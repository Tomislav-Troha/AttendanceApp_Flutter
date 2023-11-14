import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:swimming_app_client/Server/server_response.dart';
import 'package:swimming_app_client/Server/server_service.dart';
import '../Constants.dart';
import '../Managers/token_manager.dart';
import '../Models/user_model.dart';
import 'package:http/http.dart' as http;

const urlApi = url;
String? token;

class EmployeeAdminProvider extends ChangeNotifier {


  Future<ServerResponse> getUserEmployee() async {
    var url = 'user/getUserByEmployee';

    var server = await ServerService().executeGetRequest(url);
    var serverResponse =  ServerResponse(server);

    if(serverResponse.isSuccessful){
      if(serverResponse.result is List<dynamic>){
        List<UserResponseModel> responseModels = (serverResponse.result as List<dynamic>)
            .map((item) => UserResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        serverResponse.result = responseModels;
      }
    } else {
      serverResponse.error = "Error while getting user for employee ${server.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> deleteUserEmployee(int id) async {
    var url = 'user/deleteUser/$id';

    var server = await ServerService().executeDeleteRequest(url);
    var serverResponse =  ServerResponse(server);

    if(serverResponse.isSuccessful){
      serverResponse.result = "User deleted successfully";
    } else {
      serverResponse.error = "Error while deleting user ${server.reasonPhrase}";
    }

    return serverResponse;
  }

}