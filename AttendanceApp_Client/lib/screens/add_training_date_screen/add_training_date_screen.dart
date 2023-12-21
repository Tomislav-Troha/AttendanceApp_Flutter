import 'package:flutter/material.dart';
import 'package:swimming_app_client/controllers/training_date_controller/training_date_controller.dart';

import '../../constants.dart';
import '../../models/training_model.dart';
import '../../models/user_model.dart';
import '../../provider/member_admin_provider.dart';
import '../../provider/training_date_provider.dart';
import '../../provider/training_provider.dart';
import '../../server_helper/server_response.dart';
import '../../widgets/app_message.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/show_multi_items.dart';

class AddTrainingDateScreen extends StatefulWidget {
  const AddTrainingDateScreen({super.key});

  @override
  State<AddTrainingDateScreen> createState() => _AddTrainingDateScreenState();
}

class _AddTrainingDateScreenState extends State<AddTrainingDateScreen> {
  List<TrainingResponseModel> _trainings = [];

  late List<UserResponseModel> usersByMember;
  late MemberAdminProvider memberAdminProvider = MemberAdminProvider();
  late TrainingDateProvider trainingDateProvider = TrainingDateProvider();
  late TrainingProvider trainingProvider = TrainingProvider();
  List<UserResponseModel> userName = [];

  TrainingDateController trainingDateController = TrainingDateController();
  TrainingResponseModel? _valueTraining;
  List<UserResponseModel> _valueMember = [];

  bool _trainingsAreLoading = false;

  void _getUsersByMember() async {
    ServerResponse userByMember = await memberAdminProvider.getUserByMember();
    if (userByMember.isSuccessful) {
      userName = userByMember.result.cast<UserResponseModel>()
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
    trainingDateController.requestModel.trainingModel?.iD_training =
        _valueTraining?.ID_training;
    setState(() {
      // for (var user in _valueMember) {
      //   trainingDateController.addUserToRequestModel(user);
      // }
    });

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
        body: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                child: _trainingsAreLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomDropdownButton(
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        label: "Pick a training",
                        items: _trainings
                            .map<DropdownMenuItem<TrainingResponseModel>>(
                                (TrainingResponseModel values) {
                          return DropdownMenuItem<TrainingResponseModel>(
                            value: values,
                            child: SizedBox(
                              width: 140.0,
                              child: Text(values.trainingType!),
                            ),
                          );
                        }).toList(),
                        value: _valueTraining,
                        onChanged: (value) {
                          setState(() {
                            _valueTraining = value;
                            trainingDateController.trainingID.text =
                                _valueTraining!.ID_training.toString();
                          });
                        },
                        hint: 'Training',
                      ),
              ),
              CustomTextFormField(
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
                textColor: Theme.of(context).colorScheme.onPrimary,
                controller: trainingDateController.timeFrom,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.datetime,
                onTap: () => trainingDateController.selectTimeFrom(context),
                readOnly: true,
                labelText: 'Pick time from',
                prefixIcon: Icons.access_time_filled,
                onSaved: (timeFrom) {
                  trainingDateController.requestModel.timeFrom =
                      trainingDateController.parseDate(timeFrom!);
                },
              ),
              CustomTextFormField(
                textColor: Theme.of(context).colorScheme.onPrimary,
                controller: trainingDateController.timeTo,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.datetime,
                onTap: () => trainingDateController.selectTimeTo(context),
                readOnly: true,
                labelText: 'Pick time to',
                prefixIcon: Icons.access_time_filled,
                onSaved: (timeTo) {
                  trainingDateController.requestModel.timeTo =
                      trainingDateController.parseDate(timeTo!);
                },
              ),
              CustomTextFormField(
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  controller: trainingDateController.members,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onTap: () => ShowMultiItems.showMultiMembers(
                          context, userName, (selected) {
                        setState(() {
                          _valueMember = selected;
                        });
                      }, (user) {
                        return Text("${user.name} ${user.surname}");
                      }),
                  readOnly: true,
                  labelText: 'Pick members',
                  prefixIcon: Icons.model_training_outlined),
              Wrap(
                children: _valueMember
                    .map((e) => Chip(
                          label: Text("${e.name!} ${e.surname!}"),
                        ))
                    .toList(),
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
    );
  }
}
