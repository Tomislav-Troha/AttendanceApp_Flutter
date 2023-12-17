import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/Models/attendance_model.dart';
import 'package:swimming_app_client/Models/trainingDate_model.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/attendance_provider.dart';
import 'package:swimming_app_client/Provider/member_admin_provider.dart';
import 'package:swimming_app_client/Provider/training_date_provider.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/AttendanceEmployee/attendanceEmployeeController.dart';
import 'package:swimming_app_client/Server/server_response.dart';

import '../../../Enums/attendance_desc.dart';
import '../../../Widgets/app_message.dart';
import '../../../Widgets/attendance_status.dart';
import '../../../Widgets/custom_dialog.dart';
import '../../../Widgets/custom_text_form_field.dart';
import '../../../Widgets/show_multi_items.dart';

class AttendanceEmployee extends StatefulWidget {
  const AttendanceEmployee({super.key});

  @override
  _AttendanceEmployee createState() => _AttendanceEmployee();
}

class _AttendanceEmployee extends State<AttendanceEmployee> {
  late List<TrainingDateResponseModel> trainingsForEmployees;
  late List<AttendanceResponseModel> attendances;
  late List<UserResponseModel> allMembers;
  late TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  late AttendanceProvider attendanceProvider = AttendanceProvider();
  late MemberAdminProvider memberAdminProvider = MemberAdminProvider();

  DateTime? _currentDate;

  bool isEmployee = false;
  bool isFilter = false;
  bool trainingDateIsSubmitted = false;
  bool notSet = false;

  String valueStatus = "";
  int? userID;

  List<AttendanceResponseModel>? attendList = [];
  List<UserResponseModel>? memberList = [];
  List<UserResponseModel>? _valueMember = [];

  AttendanceEmplyoeeController controller = AttendanceEmplyoeeController();
  List<String> searchTerm = [];

  void initializeAttendanceAndMembers() async {
    //initialize attendances
    ServerResponse allAttendances =
        await attendanceProvider.getAttendanceAll(userID);
    if (allAttendances.isSuccessful) {
      attendances = allAttendances.result.cast<AttendanceResponseModel>();
      for (var att in attendances) {
        attendList?.add(att);
      }
    } else {
      AppMessage.showErrorMessage(message: allAttendances.error);
    }
    //initialize members
    ServerResponse members = await memberAdminProvider.getUserByMember();
    if (members.isSuccessful) {
      allMembers = members.result.cast<UserResponseModel>();
      for (var att in allMembers) {
        memberList?.add(att);
      }
    } else {
      AppMessage.showErrorMessage(message: members.error);
    }
  }

  void initializeTrainingDates() async {
    ServerResponse allTrainingsForEmployees =
        await trainingDateProvider.getTrainingDateForEmployee(_currentDate);
    if (allTrainingsForEmployees.isSuccessful) {
      trainingsForEmployees =
          allTrainingsForEmployees.result.cast<TrainingDateResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: allTrainingsForEmployees.error);
    }
  }

  @override
  void initState() {
    super.initState();

    initializeTrainingDates();

    initializeAttendanceAndMembers();
  }

  bool attendanceDoesNotExist(int index, List? attendList, List list) {
    return !attendList!.any((element) {
      int trainingDateId = element.trainingDateModel!.iD_TrainingDate;

      return trainingDateId == list[index].iD_TrainingDate;
    });
  }

  bool condition(TrainingDateResponseModel model, List<String> searchTerm) {
    return searchTerm.isNotEmpty &&
        searchTerm.any((term) =>
            model.userModel?.userId
                ?.toString()
                .toLowerCase()
                .contains(term.toLowerCase()) ??
            false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All attendances"),
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
            future: trainingDateProvider.getTrainingDateForEmployee(null),
            builder: (context, future) {
              if (!future.hasData) {
                return const CircularProgressIndicator();
              } else {
                List<TrainingDateResponseModel>? list =
                    future.data?.result.cast<TrainingDateResponseModel>();
                List<TrainingDateResponseModel>? filteredList =
                    searchTerm.isEmpty
                        ? list
                        : list
                            ?.where((model) => condition(model, searchTerm))
                            .toList();
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
                                      controller: controller.date,
                                      iconButton: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            controller.date.clear();
                                            // trainingsForEmployees = trainingDateProvider
                                            //     .getTrainingDateForEmployee(null);
                                          });
                                        },
                                      ),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      onTap: () => {
                                            controller
                                                .selectDate(context)
                                                .then((value) => {
                                                      setState(() {
                                                        _currentDate = value;
                                                        // trainingsForEmployees = trainingDateProvider.getTrainingDateForEmployee(value);
                                                      })
                                                    })
                                          },
                                      readOnly: true,
                                      labelText: 'Sort by date',
                                      prefixIcon: Icons.date_range),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: CustomTextFormField(
                                    controller: controller.members,
                                    iconButton: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          controller.members.clear();
                                          // trainingsForEmployees = trainingDateProvider
                                          //     .getTrainingDateForEmployee(null);
                                          _valueMember = [];
                                          searchTerm = [];
                                        });
                                      },
                                    ),
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    onTap: () => {
                                          ShowMultiItems.showMultiMembers(
                                              context, memberList!,
                                              (selectedList) {
                                            setState(() {
                                              _valueMember = selectedList;
                                              for (var element
                                                  in selectedList) {
                                                searchTerm.add(
                                                    element.userId.toString());
                                              }
                                            });
                                          }, (user) {
                                            return Text(
                                                "${user.name} ${user.surname}");
                                          })
                                        },
                                    readOnly: true,
                                    labelText: 'Sort by member',
                                    prefixIcon: Icons.man),
                              ),
                              Wrap(
                                children: _valueMember!
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
                      itemCount: filteredList!.length,
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
                                if (direction == DismissDirection.endToStart) {
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
                                              onPressed: () async {
                                                ServerResponse response =
                                                    await trainingDateProvider
                                                        .deleteTrainingDate(
                                                            filteredList[index]
                                                                .iD_TrainingDate!);
                                                if (response.isSuccessful) {
                                                  AppMessage.showSuccessMessage(
                                                      message: response.result);

                                                  if (!mounted) return;
                                                  Navigator.pop(context);
                                                } else {
                                                  AppMessage.showErrorMessage(
                                                      message: response.error,
                                                      duration: 3);
                                                }
                                              },
                                            ),
                                          ))
                                    ],
                                  );
                                } else {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return CustomDialog(
                                        title:
                                            "${filteredList[index].userModel!.name} ${filteredList[index].userModel!.surname} ${filteredList[index].userModel!.userId}",
                                        message:
                                            "${filteredList[index].trainingModel!.trainingType}",
                                        children: [
                                          if (attendanceDoesNotExist(index,
                                              attendList, filteredList)) ...{
                                            DropdownButton<String>(
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  valueStatus = newValue!;
                                                });
                                              },
                                              hint: const Text("Razlog"),
                                              value: valueStatus.isNotEmpty
                                                  ? valueStatus
                                                  : null,
                                              items: <String>[
                                                AttendanceDesc.Late,
                                                AttendanceDesc.Sick
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
                                                AttendanceRequestModel
                                                    attendanceRequestModel =
                                                    AttendanceRequestModel();
                                                attendanceRequestModel.attDesc =
                                                    valueStatus;
                                                attendanceRequestModel.type =
                                                    "Ne bitno";
                                                attendanceRequestModel
                                                        .trainingModel
                                                        ?.iD_training =
                                                    filteredList[index]
                                                        .trainingModel
                                                        ?.ID_training;
                                                attendanceRequestModel
                                                        .userModel?.userId =
                                                    filteredList[index]
                                                        .userModel
                                                        ?.userId;
                                                attendanceRequestModel
                                                        .trainingDateModel
                                                        ?.iD_TrainingDate =
                                                    filteredList[index]
                                                        .iD_TrainingDate;
                                                List<UserRequestModel>
                                                    userList = [];
                                                userList.add(UserRequestModel(
                                                    surname: "",
                                                    password: "",
                                                    name: "",
                                                    email: "",
                                                    addres: "",
                                                    salt: "",
                                                    userId: 0,
                                                    username: "",
                                                    userRoleID: 0));
                                                attendanceRequestModel
                                                    .trainingDateModel
                                                    ?.userModelList = userList;

                                                attendanceProvider
                                                    .addAttendanceNotSubmitted(
                                                        attendanceRequestModel)
                                                    .then((value) => {
                                                          AppMessage
                                                              .showSuccessMessage(
                                                                  message:
                                                                      "Uspješno zabilježeno"),
                                                          Navigator.pop(context)
                                                        })
                                                    .catchError(
                                                        (error) => {
                                                              Navigator.pop(
                                                                  context),
                                                              AppMessage.showErrorMessage(
                                                                  message: error
                                                                      .toString())
                                                            })
                                                    .whenComplete(() => {
                                                          setState(() {
                                                            initializeAttendanceAndMembers();
                                                          }),
                                                        });
                                              },
                                            ),
                                          }
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ).then((value) {
                              setState(() {
                                // TrainingDateProvider trainingDateProvider =
                                //     TrainingDateProvider();
                                // var allTrainingsForEmployees =
                                //     trainingDateProvider
                                //         .getTrainingDateForEmployee(
                                //             _currentDate);
                                // trainingsForEmployees =
                                //     allTrainingsForEmployees;
                              });
                            });
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${filteredList[index].trainingModel!.trainingType} ${DateFormat('dd-MM-yyyy').format(filteredList[index].dates!.toLocal())}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Icon(Icons.access_time,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              "${DateFormat('HH:mm').format(filteredList[index].timeFrom!.toLocal())} - ${DateFormat('HH:mm').format(filteredList[index].timeTo!.toLocal())}",
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16.0),
                                        AttendanceStatusWidget(
                                          index: index,
                                          attendList: attendList,
                                          list: filteredList,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    child: Text(
                                      "${filteredList[index].userModel!.name!.substring(0, 1)}${filteredList[index].userModel!.surname!.substring(0, 1)}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ))
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
