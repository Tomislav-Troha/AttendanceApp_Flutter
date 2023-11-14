import 'package:flutter/material.dart';

class ShowErrorAlert  {

  void showError(BuildContext context, String errorMessage, Route route){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Error"),
        content: Text(errorMessage),
        actions: <Widget> [
          TextButton(
            child: Text("OK"),
            onPressed: (){
              Navigator.of(context).push(route);
            },
          )
        ],
      );
    });
  }
}