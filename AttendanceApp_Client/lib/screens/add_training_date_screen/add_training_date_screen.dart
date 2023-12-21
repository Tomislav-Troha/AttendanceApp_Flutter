import 'package:flutter/material.dart';
import 'package:swimming_app_client/controllers/training_date_controller/training_date_controller.dart';
import 'package:swimming_app_client/widgets/add_training_date/pick_training.dart';

import '../../constants.dart';
import '../../models/training_model.dart';
import '../../models/user_model.dart';
import '../../provider/member_admin_provider.dart';
import '../../provider/training_date_provider.dart';
import '../../provider/training_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/add_training_date/multi_members_choice.dart';
import '../../widgets/app_message.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/show_multi_items.dart';

class AddTrainingDateScreen extends StatefulWidget {
  const AddTrainingDateScreen({super.key});

  @override
  State<AddTrainingDateScreen> createState() => _AddTrainingDateScreenState();
}

class _AddTrainingDateScreenState extends State<AddTrainingDateScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedTimeFrom;
  DateTime? _selectedTimeTo;

  List<TrainingResponseModel> _trainings = [];

  late List<UserResponseModel> usersByMember;
  late MemberAdminProvider memberAdminProvider = MemberAdminProvider();
  late TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  late TrainingProvider trainingProvider = TrainingProvider();
  List<UserResponseModel> _userList = [];

  TrainingDateController trainingDateController = TrainingDateController();
  TrainingResponseModel? _valueTraining;
  List<UserResponseModel> _valueMember = [];

  bool _trainingsAreLoading = false;

  void _getUsersByMember() async {
    ServerResponse userByMember = await memberAdminProvider.getUserByMember();
    if (userByMember.isSuccessful) {
      _userList = userByMember.result.cast<UserResponseModel>()
          as List<UserResponseModel>;
    } else {
      AppMessage.showErrorMessage(message: userByMember.error);
    }
  }

  void _getTrainings() async {
    setState(() {
      _trainingsAreLoading = true;
    });
    ServerResponse trainingsResponse = await trainingProvider.getTraining(null);
    if (trainingsResponse.isSuccessful) {
      _trainings = trainingsResponse.result.cast<TrainingResponseModel>()
          as List<TrainingResponseModel>;

      setState(() {
        _trainingsAreLoading = false;
      });
    }
  }

  void _saveTrainingDate() async {
    if (_formKey.currentState!.validate() &&
        _selectedTimeTo != null &&
        _selectedTimeFrom != null) {
      _formKey.currentState!.save();

      trainingDateController.requestModel.trainingModel?.iD_training =
          _valueTraining?.ID_training;

      ServerResponse response = await trainingDateProvider
          .addTrainingDate(trainingDateController.requestModel);
      if (response.isSuccessful) {
        AppMessage.showSuccessMessage(
            message: "Successfully added training date");
        setState(() {
          trainingDateController.clearControllers();
        });
      } else {
        AppMessage.showErrorMessage(message: response.error);
      }
    }
  }

  void _showMultiMembers() {
    ShowMultiItems.showMultiMembers(context, _userList, (selected) {
      setState(() {
        _valueMember = selected;
      });
    }, (item) {
      bool isSelected = _valueMember.contains(item);
      return Text(
        "${item.name} ${item.surname}",
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSecondary,
        ),
      );
    }, _valueMember);
  }

  @override
  void initState() {
    super.initState();
    _getUsersByMember();
    _getTrainings();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add attendance"),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                PickTraining(
                  trainingsAreLoading: _trainingsAreLoading,
                  trainings: _trainings,
                  valueTraining: _valueTraining,
                  onChanged: (value) {
                    setState(() {
                      _valueTraining = value;
                      trainingDateController.trainingID.text =
                          _valueTraining!.ID_training.toString();
                    });
                  },
                ),
                CustomTextFormField(
                  validate: (trainingDate) {
                    if (trainingDate == null || trainingDate.isEmpty) {
                      return "Please pick a date of a training";
                    }
                    if (trainingDateController.parseDate(trainingDate) ==
                            null ||
                        trainingDateController
                            .parseDate(trainingDate)!
                            .isBefore(DateTime.now())) {
                      return "Please select a date";
                    }
                    return null;
                  },
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  controller: trainingDateController.date,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.datetime,
                  onTap: () => trainingDateController.selectDate(context),
                  readOnly: true,
                  labelText: 'Pick training date',
                  prefixIcon: Icons.date_range,
                  onSaved: (trainingDate) {
                    trainingDateController.requestModel.dates =
                        trainingDateController.parseDate(trainingDate!);
                  },
                ),
                CustomTextFormField(
                  validate: (timeFrom) {
                    if (timeFrom == null || timeFrom.isEmpty) {
                      return "Please pick a time from";
                    }
                    return null;
                  },
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  controller: trainingDateController.timeFrom,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    _selectedTimeFrom =
                        await trainingDateController.selectTime(context);
                  },
                  readOnly: true,
                  labelText: 'Pick time from',
                  prefixIcon: Icons.access_time_filled,
                ),
                CustomTextFormField(
                  validate: (timeTo) {
                    if (timeTo == null || timeTo.isEmpty) {
                      return "Please pick a time to";
                    }
                    return null;
                  },
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  controller: trainingDateController.timeTo,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    _selectedTimeTo =
                        await trainingDateController.selectTime(context);
                  },
                  readOnly: true,
                  labelText: 'Pick time to',
                  prefixIcon: Icons.access_time_filled,
                ),
                Visibility(
                  visible: _valueMember.isEmpty,
                  child: CustomTextFormField(
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      controller: trainingDateController.members,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      onTap: _showMultiMembers,
                      readOnly: true,
                      labelText: 'Pick members',
                      prefixIcon: Icons.model_training_outlined),
                ),
                MultiMemberChoice(
                  valueMember: _valueMember,
                  showMultiMembers: _showMultiMembers,
                ),
                CustomTextButton(
                  textSize: 18,
                  text: "Save",
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: _saveTrainingDate,
                ),
                const SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
