import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../managers/token_manager.dart';
import '../models/change_password_model.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';
import '../server_helper/server_response.dart';
import '../server_helper/server_service.dart';

const urlApi = url;
String? token;

class UserProvider {
  bool get isUserLoggedIn => token != null;

  Future<RegisterResponseModel> register(
      RegisterRequestModel model, BuildContext context) async {
    var url = Uri.parse('$urlApi/auth/register');

    var response = await http.post(url, body: jsonEncode(model), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "Access-Control-Allow-Origin": "*",
    });
    if (response.statusCode == 200 || response.statusCode == 400) {
      var responseData =
          RegisterResponseModel.fromJson(json.decode(response.body));
      return responseData;
    } else {
      throw Exception("Register user failed");
    }
  }

  Future<LoginResponseModel> login(
      LoginRequestModel model, BuildContext context) async {
    var url = Uri.parse('$urlApi/auth/login');

    var response = await http.post(url, body: jsonEncode(model), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "Access-Control-Allow-Origin": "*",
    });
    if (response.statusCode == 200 || response.statusCode == 400) {
      var responseData =
          LoginResponseModel.fromJson(json.decode(response.body));
      token = responseData.token;
      TokenManager.setToken(token!);
      return responseData;
    } else {
      throw Exception("Login user failed ${response.reasonPhrase}");
    }
  }

  Future<ServerResponse> updateUser(UserRequestModel model, int id) async {
    var url = 'user/updateUser/$id';

    var response = await ServerService().executePutRequest(url, model);
    var serverResponse = ServerResponse(response);

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
          "Error while updating user ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> setProfileImage(
      UserRequestModel? model, int id) async {
    var url = 'user/setProfileImage/$id';

    var response = await ServerService().executePutRequest(url, model);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      serverResponse.result = UserResponseModel.fromJson(serverResponse.result);
    } else {
      serverResponse.error =
          "Error while updating user ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ServerResponse> getUserByID(int? id) async {
    var url = 'user/getUserByID/$id';

    var response = await ServerService().executeGetRequest(url);
    var serverResponse = ServerResponse(response);

    if (serverResponse.isSuccessful) {
      if (serverResponse.result is List<dynamic>) {
        List<UserResponseModel> responseModels =
            (serverResponse.result as List<dynamic>)
                .map((item) =>
                    UserResponseModel.fromJson(item as Map<String, dynamic>))
                .toList();

        serverResponse.result = responseModels;
      } else {
        serverResponse.result =
            UserResponseModel.fromJson(serverResponse.result);
      }
    } else {
      serverResponse.error =
          "Error while getting user ${response.reasonPhrase}";
    }
    return serverResponse;
  }

  Future<ChangePasswordResponseModel> changePassword(
      ChangePasswordRequestModel model) async {
    var url = Uri.parse('$urlApi/passwordReset/resetPassword');

    var response = await http.put(url, body: jsonEncode(model), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "Access-Control-Allow-Origin": "*"
    });

    if (response.statusCode == 200 || response.statusCode == 400) {
      var responseData =
          ChangePasswordResponseModel.fromJson(json.decode(response.body));
      return responseData;
    } else {
      throw Exception(
          "Error due changing password user ${response.reasonPhrase}");
    }
  }
}
