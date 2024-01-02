import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceEmployeeController {
  var date = TextEditingController();
  var members = TextEditingController();

  DateTime? selectedDate;
  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      date.text = DateFormat("dd-MM-yyyy").format(picked);
      return picked;
    }
    return null;
  }
}
