import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/training_model.dart';
import '../custom_dropdown_button.dart';

class PickTraining extends StatelessWidget {
  const PickTraining(
      {super.key,
      required this.trainingsAreLoading,
      required this.trainings,
      required this.valueTraining,
      required this.onChanged});

  final bool trainingsAreLoading;
  final List<TrainingResponseModel> trainings;
  final TrainingResponseModel? valueTraining;
  final void Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding),
      child: trainingsAreLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomDropdownButton(
              textColor: Theme.of(context).colorScheme.onPrimary,
              label: "Pick a training",
              items: trainings.map<DropdownMenuItem<TrainingResponseModel>>(
                  (TrainingResponseModel values) {
                return DropdownMenuItem<TrainingResponseModel>(
                  value: values,
                  child: SizedBox(
                    width: 140.0,
                    child: Text(values.trainingType!),
                  ),
                );
              }).toList(),
              value: valueTraining,
              onChanged: onChanged,
              hint: 'Training',
            ),
    );
  }
}
