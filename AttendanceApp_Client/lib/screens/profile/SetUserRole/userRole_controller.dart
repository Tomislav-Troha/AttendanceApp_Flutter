import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/contract_model.dart';

class UserRoleController extends GetxController {
  late ContractRequestModel requestModel = ContractRequestModel();
  late ContractResponseModel responseModel = ContractResponseModel();

  var roleID = TextEditingController();
  var roleName = TextEditingController();
  var roleDesc = TextEditingController();
  var dateFrom = TextEditingController();
  var dateTo = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onInit() {
    roleID = TextEditingController(text: "");
    roleName = TextEditingController(text: "");
    roleDesc = TextEditingController(text: "");
    dateFrom = TextEditingController(text: "");
    dateTo = TextEditingController(text: "");
    super.onInit();
  }

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? selectedStartDate : selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      if (isStartDate) {
        dateFrom.text = DateFormat("dd-MM-yyyy").format(picked);
        selectedStartDate = DateTime(picked.year, picked.month, picked.day);
      } else {
        dateTo.text = DateFormat("dd-MM-yyyy").format(picked);
        selectedEndDate = DateTime(picked.year, picked.month, picked.day);
      }
    }
  }
}
