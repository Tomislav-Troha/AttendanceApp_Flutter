import 'package:flutter/material.dart';
import 'package:swimming_app_client/models/attendance_model.dart';
import 'package:swimming_app_client/models/trainingDate_model.dart';
import 'package:swimming_app_client/models/user_model.dart';
import 'package:swimming_app_client/provider/member_admin_provider.dart';
import 'package:swimming_app_client/provider/training_date_provider.dart';
import 'package:swimming_app_client/widgets/attendance/attendance_info.dart';

import '../../controllers/attendance_employee/attendance_employee_controller.dart';
import '../../enums/attendance_description.dart';
import '../../provider/attendance_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/show_multi_items.dart';

class AttendanceEmployee extends StatefulWidget {
  const AttendanceEmployee({super.key});

  @override
  State<AttendanceEmployee> createState() => _AttendanceEmployeeState();
}

class _AttendanceEmployeeState extends State<AttendanceEmployee> {
  List<TrainingDateResponseModel> trainingsDatesForEmployeesList = [];
  List<AttendanceResponseModel> attendancesList = [];
  List<UserResponseModel> membersList = [];

  TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  AttendanceProvider attendanceProvider = AttendanceProvider();
  MemberAdminProvider memberAdminProvider = MemberAdminProvider();

  DateTime? _currentDate;

  bool isEmployee = false;
  bool isFilter = false;
  bool trainingDateIsSubmitted = false;
  bool notSet = false;

  String valueStatus = "";
  int? userID;

  List<UserResponseModel> _valueMember = [];

  final AttendanceEmplyoeeController _controller =
      AttendanceEmplyoeeController();

  List<String> searchTerm = [];

  // Future for training dates
  late Future<ServerResponse> _trainingDatesFuture;

  void _initData() {
    _trainingDatesFuture =
        trainingDateProvider.getTrainingDateForEmployee(_currentDate);

    _getMembers();
    _getAttendanceAndMembers();
  }

  void _getAttendanceAndMembers() async {
    ServerResponse allAttendances =
        await attendanceProvider.getAttendanceAll(userID);
    if (allAttendances.isSuccessful) {
      attendancesList = allAttendances.result.cast<AttendanceResponseModel>()
          as List<AttendanceResponseModel>;
    } else {
      AppMessage.showErrorMessage(message: allAttendances.error);
    }
  }

  void _getMembers() async {
    ServerResponse members = await memberAdminProvider.getUserByMember();
    if (members.isSuccessful) {
      membersList =
          members.result.cast<UserResponseModel>() as List<UserResponseModel>;
    } else {
      AppMessage.showErrorMessage(message: members.error);
    }
  }

  void _addNotSubmittedAttendance(
      List<TrainingDateResponseModel> filteredList, int index) async {
    AttendanceRequestModel attendanceRequestModel = AttendanceRequestModel();
    attendanceRequestModel.attDesc = valueStatus;
    attendanceRequestModel.type = "Some text";
    attendanceRequestModel.trainingModel?.iD_training =
        filteredList[index].trainingModel?.ID_training;
    attendanceRequestModel.userModel?.userId =
        filteredList[index].userModel?.userId;
    attendanceRequestModel.trainingDateModel?.iD_TrainingDate =
        filteredList[index].iD_TrainingDate;
    List<UserRequestModel>? usersList = [];
    usersList.add(UserRequestModel());
    attendanceRequestModel.trainingDateModel?.userModelList = usersList;

    final response = await attendanceProvider
        .addAttendanceNotSubmitted(attendanceRequestModel);

    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: "Done!");
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {});
    } else {
      AppMessage.showErrorMessage(message: response.error);
    }
  }

  bool _attendanceDoesNotExist(int index, List? attendList, List list) {
    return !attendList!.any((element) {
      int trainingDateId = element.trainingDateModel!.iD_TrainingDate;

      return trainingDateId == list[index].iD_TrainingDate;
    });
  }

  List<TrainingDateResponseModel> _applyFilters(
      List<TrainingDateResponseModel> list) {
    if (searchTerm.isEmpty) {
      return list;
    }
    return list.where((model) {
      String userIdLower =
          model.userModel?.userId?.toString().toLowerCase() ?? '';
      return searchTerm.any((term) => userIdLower.contains(term.toLowerCase()));
    }).toList();
  }

  void _deleteAttendance(
      List<TrainingDateResponseModel> filteredList, int index) async {
    ServerResponse response = await trainingDateProvider
        .deleteTrainingDate(filteredList[index].iD_TrainingDate!);
    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: response.result);

      if (!mounted) return;
      Navigator.pop(context);
    } else {
      AppMessage.showErrorMessage(message: response.error, duration: 3);
    }
  }

  void _pickDate() async {
    final result = await _controller.selectDate(context);
    setState(() {
      _currentDate = result;
    });
  }

  void _clearFilter() {
    setState(() {
      _controller.members.clear();
      _valueMember = [];
      searchTerm = [];
    });
  }

  void _showMultiMembers() {
    ShowMultiItems.showMultiMembers(
      context,
      membersList,
      (selectedList) {
        setState(() {
          _valueMember = selectedList;
          for (var element in selectedList) {
            searchTerm.add(element.userId.toString());
          }
        });
      },
      (user) {
        return Text("${user.name} ${user.surname}");
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendances"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                setState(() {
                  isFilter = !isFilter;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder(
            future: _trainingDatesFuture,
            builder: (context, future) {
              if (!future.hasData) {
                return const CircularProgressIndicator();
              } else {
                var list =
                    future.data!.result.cast<TrainingDateResponseModel>();
                var filteredList = _applyFilters(list);
                return Column(
                  children: <Widget>[
                    Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: isFilter,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.linearToEaseOut,
                          opacity: isFilter ? 1 : 0,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: 300,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CustomTextFormField(
                                      controller: _controller.date,
                                      iconButton: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _controller.date.clear();
                                          });
                                        },
                                      ),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      onTap: _pickDate,
                                      readOnly: true,
                                      labelText: 'Sort by date',
                                      prefixIcon: Icons.date_range),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: CustomTextFormField(
                                    controller: _controller.members,
                                    iconButton: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: _clearFilter,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    onTap: _showMultiMembers,
                                    readOnly: true,
                                    labelText: 'Sort by member',
                                    prefixIcon: Icons.man),
                              ),
                              Wrap(
                                children: _valueMember
                                    .map((e) => Chip(
                                          label:
                                              Text("${e.name!} ${e.surname!}"),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            background: Container(
                              color: Colors.blue,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    return AlertDialog(
                                      actions: [
                                        Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: TextButton(
                                                child: const Text(
                                                  "Delete attendance",
                                                ),
                                                onPressed: () {
                                                  _deleteAttendance(
                                                      filteredList, index);
                                                },
                                              ),
                                            ))
                                      ],
                                    );
                                  } else {
                                    return CustomDialog(
                                      title:
                                          "${filteredList[index].userModel!.name} ${filteredList[index].userModel!.surname} ${filteredList[index].userModel!.userId}",
                                      message:
                                          "${filteredList[index].trainingModel!.trainingType}",
                                      children: [
                                        if (_attendanceDoesNotExist(index,
                                            attendancesList, filteredList)) ...{
                                          DropdownButton<String>(
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                valueStatus = newValue!;
                                              });
                                            },
                                            hint: const Text("Reason"),
                                            value: valueStatus.isNotEmpty
                                                ? valueStatus
                                                : null,
                                            items: <String>[
                                              AttendanceDescription.Late,
                                              AttendanceDescription.Sick
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                          TextButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              _addNotSubmittedAttendance(
                                                  filteredList, index);
                                            },
                                          ),
                                        }
                                      ],
                                    );
                                  }
                                },
                              );
                            },
                            child: AttendanceInfo(
                              filteredList: filteredList,
                              attendancesList: attendancesList,
                              index: index,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
