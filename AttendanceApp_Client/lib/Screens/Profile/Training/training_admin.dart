import 'package:flutter/material.dart';
import 'package:swimming_app_client/Screens/Components/background.dart';
import 'package:swimming_app_client/Server/server_response.dart';
import 'package:swimming_app_client/responsive.dart';

import '../../../Models/training_model.dart';
import '../../../Provider/training_provider.dart';
import '../../../Widget-Helpers/app_message.dart';
import '../../../Widget-Helpers/custom_dialog.dart';

class TrainingAdmin extends StatefulWidget {
  @override
  _TrainingAdmin createState() => _TrainingAdmin();

}
  class _TrainingAdmin extends State<TrainingAdmin> {

    TrainingProvider trainingProvider = TrainingProvider();
    List<TrainingResponseModel>? trainingList;
    TrainingRequestModel trainingRequestModel = TrainingRequestModel();
    TextEditingController trainingTypeController = TextEditingController();

    void getAllTrainings() async {
      ServerResponse allTrainings = await trainingProvider.getTraining(null);
      if (allTrainings.isSuccessful){
      trainingList = allTrainings.result;
      }
      else{
        AppMessage.showErrorMessage(message: allTrainings.error);
      }

    }

    void updateTraining(TrainingRequestModel model) async {
      ServerResponse response = await trainingProvider.updateTraining(model);
      if(response.isSuccessful){
        AppMessage.showSuccessMessage(message: response.result.toString());
        if(!mounted) return;
        Navigator.pop(context);
        setState(() {

        });
      }
      else{
        AppMessage.showErrorMessage(message: response.error);
      }
    }

    void deleteTraining(int id) async {
      ServerResponse response = await trainingProvider.deleteTraining(id);
      if(response.isSuccessful){
        AppMessage.showSuccessMessage(message: response.result.toString());
      }
      else{
        AppMessage.showErrorMessage(message: response.error);
      }
    }

    @override
    void initState() {
      getAllTrainings();


      super.initState();
    }

  @override
  Widget build(BuildContext context) {

    return Background(
      child: Responsive(
        mobile: Scaffold(
          appBar: AppBar(
            title: const Text("Trainings"),
            automaticallyImplyLeading: true,
          ),
          body: Center(
            child: FutureBuilder(
              future: trainingProvider.getTraining(null),
              builder: (context, future){
                if(!future.hasData) {
                  return const CircularProgressIndicator();
                }
                else if(future.data!.result.isEmpty){
                  return const Text("There is no training yet", textScaleFactor: 1.6,);
                }
                else{
                  List<TrainingResponseModel>? list = future.data?.result;
                  return ListView.builder(
                    itemCount: list!.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                          onTap: ()  {
                            showDialog(context: context,
                              builder: (context) {
                                return CustomDialog(
                                  title: "Training - ${list[index].trainingType}",
                                  message: "",
                                  children: [
                                    TextButton(
                                      child: const Text("Delete", style: TextStyle(color: Colors.red),),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        showDialog(context: context, builder: (context) {
                                          return CustomDialog(
                                            title: "Delete training",
                                            message: "Are you sure you want to delete this training?",
                                            children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      child: const Text("No"),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text("Yes"),
                                                      onPressed: () {
                                                        deleteTraining(list[index].ID_training!);
                                                      },
                                                    )
                                                  ],
                                                ),
                                            ],
                                          );
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Edit"),
                                      onPressed: (){
                                        trainingTypeController.text = list[index].trainingType!;
                                        Navigator.pop(context);
                                        showDialog(context: context, builder: (context) {
                                          return CustomDialog(
                                            title: "Edit training",
                                            message: "",
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextFormField(
                                                    controller: trainingTypeController,
                                                    decoration: const InputDecoration(
                                                      hintText: "Training type",
                                                    ),
                                                    onChanged: (value) {
                                                      list[index].trainingType = value;
                                                    },
                                                  ),

                                                  TextButton(
                                                    child: const Text("Save"),
                                                    onPressed: (){
                                                      trainingRequestModel.trainingType = trainingTypeController.text;
                                                      trainingRequestModel.iD_training = list[index].ID_training;
                                                      trainingRequestModel.code = list[index].code;
                                                      updateTraining(trainingRequestModel);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(list[index].trainingType!),
                            ),
                          )
                      );
                    },
                  );
                }
              },
            ),
          ),
        ), desktop: Text("Desktop")),
      );

  }



  }
