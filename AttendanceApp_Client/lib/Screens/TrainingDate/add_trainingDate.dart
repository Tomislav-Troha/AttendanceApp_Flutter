import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swimming_app_client/Screens/TrainingDate/trainingDate_controller.dart';
import 'package:swimming_app_client/Server/server_response.dart';

import '../../Constants.dart';
import '../../Models/training_model.dart';
import '../../Models/user_model.dart';
import '../../Provider/member_admin_provider.dart';
import '../../Provider/training_date_provider.dart';
import '../../Provider/training_provider.dart';
import '../../Widgets/app_message.dart';
import '../../Widgets/custom_dropdown_button.dart';
import '../../Widgets/custom_text_button.dart';
import '../../Widgets/custom_text_form_field.dart';
import '../../Widgets/show_multi_items.dart';

class AddTrainingDate extends StatefulWidget {
  const AddTrainingDate({super.key});

  @override
  _AddTrainingDate createState() => _AddTrainingDate();
}

class _AddTrainingDate extends State<AddTrainingDate> {
  late List<TrainingResponseModel> trainings;
  late List<UserResponseModel> usersByMember;
  late MemberAdminProvider memberAdminProvider = MemberAdminProvider();
  late TrainingProvider trainingProvider = TrainingProvider();
  List<UserResponseModel> userName = [];

  TrainingDateController trainingDateController = TrainingDateController();
  TrainingResponseModel? _valueTraining = null;
  List<UserResponseModel> _valueMember = [];

  void initAllTrainings() async {
    ServerResponse allTrainings = await trainingProvider.getTraining(null);
    if (allTrainings.isSuccessful) {
      trainings = allTrainings.result.cast<TrainingResponseModel>();
    }

    ServerResponse userByMember = await memberAdminProvider.getUserByMember();
    if (userByMember.isSuccessful) {
      userName = userByMember.result.cast<UserResponseModel>()
          as List<UserResponseModel>;
    } else {
      AppMessage.showErrorMessage(message: userByMember.error);
    }
  }

  @override
  void initState() {
    super.initState();

    initAllTrainings();
  }

  @override
  Widget build(BuildContext context) {
    final trainingDateProvider = Provider.of<TrainingDateProvider>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dodaj dolazak"),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          child: Column(
            children: [
              FutureBuilder(
                future: trainingProvider.getTraining(null),
                builder: (context, future) {
                  if (!future.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: defaultPadding),
                        child: CustomDropdownButton(
                            label: "Pick a training",
                            items: trainings
                                .map<DropdownMenuItem<TrainingResponseModel>>(
                                    (TrainingResponseModel? values) {
                              return DropdownMenuItem<TrainingResponseModel>(
                                value: values,
                                child: SizedBox(
                                  width: 140.0,
                                  child: Text(values!.trainingType!),
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
                            hint: 'Training'));
                  }
                },
              ),
              CustomTextFormField(
                  controller: trainingDateController.date,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.datetime,
                  onTap: () => trainingDateController.selectDate(context),
                  readOnly: true,
                  labelText: 'Odaberi datum treninga',
                  prefixIcon: Icons.date_range),
              CustomTextFormField(
                  controller: trainingDateController.timeFrom,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.datetime,
                  onTap: () => trainingDateController.selectTimeFrom(context),
                  readOnly: true,
                  labelText: 'Odaberi vrijeme treninga (Od)',
                  prefixIcon: Icons.access_time_filled),
              CustomTextFormField(
                  controller: trainingDateController.timeTo,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.datetime,
                  onTap: () => trainingDateController.selectTimeTo(context),
                  readOnly: true,
                  labelText: 'Odaberi vrijeme treninga (Do)',
                  prefixIcon: Icons.access_time_filled),
              CustomTextFormField(
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
                  labelText: 'Odaberi članove',
                  prefixIcon: Icons.model_training_outlined),
              Wrap(
                children: _valueMember!
                    .map((e) => Chip(
                          label: Text("${e.name!} ${e.surname!}"),
                        ))
                    .toList(),
              ),
              CustomTextButton(
                textSize: 18,
                text: "Spremi",
                onPressed: () async {
                  String? errorMessage =
                      trainingDateController.validateTrainingDateInputs(
                          trainingID: trainingDateController.trainingID.text,
                          date: trainingDateController.date.text,
                          timeFrom: trainingDateController.timeFrom.text,
                          timeTo: trainingDateController.timeTo.text);
                  if (errorMessage != null) {
                    AppMessage.showErrorMessage(
                        message: errorMessage, duration: 1);
                  } else if (_valueMember!.isEmpty) {
                    AppMessage.showErrorMessage(
                        message: "Odaberi članove", duration: 1);
                  } else {
                    trainingDateController.requestModel.trainingModel
                        ?.iD_training = _valueTraining?.ID_training;
                    trainingDateController.requestModel.dates =
                        trainingDateController
                            .parseDate(trainingDateController.date.text);
                    trainingDateController.requestModel.timeFrom =
                        trainingDateController
                            .parseTime(trainingDateController.timeFrom.text);
                    trainingDateController.requestModel.timeTo =
                        trainingDateController
                            .parseTime(trainingDateController.timeTo.text);

                    setState(() {
                      for (var user in _valueMember!) {
                        trainingDateController.addUserToRequestModel(user);
                      }
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
                },
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
