import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../managers/token_manager.dart';

const urlApi = url;

Uri generateUrl(String endpoint) {
  return Uri.parse('$urlApi/$endpoint/');
}

class ServerService {
  Future<http.Response> executeGetRequest(String endpoint) async {
    var url = generateUrl(endpoint);
    var token = await TokenManager.getToken('token');

    var response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token'
      },
    );
    return response;
  }

  Future<http.Response> executeDeleteRequest(String endpoint) async {
    var url = generateUrl(endpoint);
    var token = await TokenManager.getToken('token');

    var response = await http.delete(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token'
    });
    return response;
  }

  Future<http.Response> executePostRequest(
      String endpoint, dynamic model) async {
    var url = generateUrl(endpoint);
    var token = await TokenManager.getToken('token');

    var response = await http.post(url, body: jsonEncode(model), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token'
    });
    return response;
  }

  Future<http.Response> executePutRequest(
      String endpoint, dynamic model) async {
    var url = generateUrl(endpoint);
    var token = await TokenManager.getToken('token');

    var response = await http.put(url, body: jsonEncode(model), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "Access-Control-Allow-Origin": "*",
      'Authorization': 'Bearer $token'
    });
    return response;
  }
}
