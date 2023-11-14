import 'package:flutter/material.dart';

class MyAttendancesMembers extends StatefulWidget{

  _MyAttendancesMembers createState() => _MyAttendancesMembers();
}

class _MyAttendancesMembers extends State<MyAttendancesMembers>{
  @override
  Widget build(BuildContext context) {
   return SizedBox(
     child: Scaffold(
       appBar: AppBar(
         title: const Text("My attendances"),
       ),
     ),
   );
  }
}