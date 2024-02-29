import 'package:flutter/material.dart';
import 'package:swimming_app_client/models/attendance_model.dart';
import 'package:swimming_app_client/models/trainingDate_model.dart';
import 'package:swimming_app_client/models/user_model.dart';
import 'package:swimming_app_client/provider/member_admin_provider.dart';
import 'package:swimming_app_client/provider/training_date_provider.dart';
import 'package:swimming_app_client/widgets/attendance/attendance_info.dart';
import 'package:swimming_app_client/widgets/attendance/filter_attendances.dart';
import 'package:swimming_app_client/widgets/attendance/on_delete_attendance.dart';

import '../../controllers/attendance_employee/attendance_employee_controller.dart';
import '../../provider/attendance_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/show_modal_from_top.dart';
import '../../widgets/show_multi_items.dart';

class AttendanceEmployee extends StatefulWidget {
  const AttendanceEmployee({
    super.key,
    required this.newTrainingDate,
  });

  final List<TrainingDateResponseModel>? newTrainingDate;

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

  final AttendanceEmployeeController _controller =
      AttendanceEmployeeController();

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

  Future<bool> _addNotSubmittedAttendance(
      TrainingDateResponseModel item) async {
    AttendanceRequestModel attendanceRequestModel = AttendanceRequestModel();
    attendanceRequestModel.attDesc = valueStatus;
    attendanceRequestModel.type = "Some text";
    attendanceRequestModel.trainingModel?.iD_training =
        item.trainingModel?.ID_training;
    attendanceRequestModel.userModel?.userId = item.userModel?.userId;
    attendanceRequestModel.trainingDateModel?.iD_TrainingDate =
        item.iD_TrainingDate;
    List<UserRequestModel>? usersList = [];
    usersList.add(UserRequestModel());
    attendanceRequestModel.trainingDateModel?.userModelList = usersList;

    final response = await attendanceProvider
        .addAttendanceNotSubmitted(attendanceRequestModel);

    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: "Done!");
      if (!mounted) return false;
      Navigator.pop(context);
      return true;
    } else {
      AppMessage.showErrorMessage(message: response.error);
      return false;
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

  Future<bool> _deleteAttendance(
      TrainingDateResponseModel trainingDate, int index) async {
    ServerResponse response = await trainingDateProvider.deleteTrainingDate(
      trainingDate.iD_TrainingDate!,
    );

    if (response.isSuccessful) {
      if (!mounted) return false;
      AppMessage.showSuccessMessage(
        message: response.result,
        context: context,
      );
      return true;
    } else if (response.error != null &&
        response.error!.contains("This training date is already submitted")) {
      setState(() {
        trainingsDatesForEmployeesList.insert(index, trainingDate);
      });
      return false;
    } else {
      if (!mounted) return false;
      AppMessage.showErrorMessage(
        message: response.error,
        duration: 3,
        context: context,
      );
      return false;
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
    ShowMultiItems.showMultiMembers(context, membersList, (selectedList) {
      setState(() {
        _valueMember = selectedList;
        for (var element in selectedList) {
          searchTerm.add(element.userId.toString());
        }
      });
    }, (user) {
      return Text("${user.name} ${user.surname}");
    }, _valueMember);
  }

  void _showDialogOnDismissed(
    List<TrainingDateResponseModel> filteredList,
    int index,
    DismissDirection direction,
    List<TrainingDateResponseModel> list,
  ) async {
    final item = filteredList[index];
    final result = await showDialog(
      context: context,
      builder: (context) {
        trainingsDatesForEmployeesList.remove(item);
        return OnDeleteAttendance(
          deleteAttendance: () async {
            final isDeleted = await _deleteAttendance(item, index);
            if (!mounted) return;
            Navigator.pop(context, isDeleted);
          },
          item: item,
        );
      },
    );

    if (result == null) {
      setState(() {
        trainingsDatesForEmployeesList.insert(index, item);
      });
    }
  }

  void _openFilterAttendances() {
    setState(() {
      isFilter = !isFilter;
    });
    showModalFromTop(
      context,
      FilterAttendances(
        controller: _controller,
        onPressed: () {
          setState(() {
            _controller.date.clear();
          });
        },
        pickDate: _pickDate,
        clearFilter: _clearFilter,
        valueMember: _valueMember,
        onTap: _showMultiMembers,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _initData();
  }

  @override
  void dispose() {
    _controller.members.dispose();
    _controller.date.dispose();
    super.dispose();
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
              onPressed: _openFilterAttendances,
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
                List<TrainingDateResponseModel> list =
                    future.data!.result.cast<TrainingDateResponseModel>();

                if (widget.newTrainingDate != null &&
                    widget.newTrainingDate!.isNotEmpty) {
                  for (var newTrainingDate in widget.newTrainingDate!) {
                    list.add(newTrainingDate);
                  }
                }
                trainingsDatesForEmployeesList = _applyFilters(list);
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: trainingsDatesForEmployeesList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.red,
                              ),
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
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _showDialogOnDismissed(
                                trainingsDatesForEmployeesList,
                                index,
                                direction,
                                list,
                              );
                            },
                            child: AttendanceInfo(
                              training: trainingsDatesForEmployeesList[index],
                              attendancesList: attendancesList,
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
