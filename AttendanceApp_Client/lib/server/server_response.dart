import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerResponse {
  bool isSuccessful = false;
  dynamic result;
  String? error;

  ServerResponse(http.Response? response) {
    if (response == null) throw ArgumentError("response");

    isSuccessful = response.statusCode == 200;
    try {
      if (response.statusCode == 403) {
        // Forbidden
        error = "User has no rights";
      } else if (response.statusCode == 500) {
        //InternalServerError
        Map<String, dynamic> jsonException = jsonDecode(response.body);

        String errorMessage = jsonException["ExceptionMessage"] ??
            jsonException["Message"] ??
            'Server did not return a message';

        error = "Error: $errorMessage";
      }else if(response.statusCode == 404){
        error = "Not found";
      }
      else if(response.statusCode == 400){
        Map<String, dynamic> jsonException = jsonDecode(response.body);

        var errors = jsonException["errors"];
        var errorKey = errors.keys.first;
        var errorMessage = errors[errorKey].first;
        String outputMessage = '${'400 -> ' '$errorKey'}: $errorMessage';
        String finalMessage = outputMessage;

        error = "Error: $finalMessage";
      }
      else {
        result = json.decode(response.body);
      }
    } catch (ex) {
      error = "Unknown error: ${response.body }${ex.toString()}}";
    }
  }

  ServerResponse.xmlHttpRequestError() {
    isSuccessful = false;
    error = 'Failed to connect to the server!';
  }

  ServerResponse.fromException(Exception e) {
    isSuccessful = false;
    error = e.toString();
  }
}