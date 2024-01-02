import 'package:flutter/material.dart';

import '../../controllers/attendance_employee/attendance_employee_controller.dart';
import '../../models/user_model.dart';
import '../custom_text_form_field.dart';

class FilterAttendances extends StatelessWidget {
  const FilterAttendances({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.pickDate,
    required this.clearFilter,
    required this.valueMember,
    required this.onTap,
  });

  final AttendanceEmployeeController controller;
  final void Function() onPressed;
  final void Function() pickDate;
  final void Function() clearFilter;
  final void Function()? onTap;
  final List<UserResponseModel> valueMember;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomTextFormField(
              controller: controller.date,
              iconButton: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onPressed,
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              onTap: pickDate,
              readOnly: true,
              labelText: 'Sort by date',
              prefixIcon: Icons.date_range,
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: CustomTextFormField(
            controller: controller.members,
            iconButton: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearFilter,
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            onTap: onTap,
            readOnly: true,
            labelText: 'Sort by member',
            prefixIcon: Icons.man,
          ),
        ),
        Wrap(
          children: valueMember
              .map((e) => Chip(
                    label: Text("${e.name!} ${e.surname!}"),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
