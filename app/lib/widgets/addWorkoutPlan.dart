import 'package:app/main.dart';
import 'package:app/models/planmodel.dart';
import 'package:app/screens/workoutspage.dart';
import 'package:app/widgets/dialogButton.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

import '../dbHelper/mongodb.dart';

class AddWorkoutPlan extends StatefulWidget {
  AddWorkoutPlan({Key? key,}) : super(key: key);

  @override
  State<AddWorkoutPlan> createState() => _AddWorkoutPlanState();
}

class _AddWorkoutPlanState extends State<AddWorkoutPlan> {
  late TextEditingController titleController;
  late TextEditingController muscleController;
  late TextEditingController nameController;
  late TextEditingController setsController;
  late TextEditingController repsController;
  late List<Exercise> exercises = [];
  final formKey = GlobalKey<FormState>();
  final dialogKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    muscleController = TextEditingController();
    nameController = TextEditingController();
    repsController = TextEditingController();
    setsController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    muscleController.dispose();
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text("Add Plan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                  padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
                    child: TextFormField(
                      maxLength: 14,
                      decoration: InputDecoration(
                        label: Text('Title'),
                      ),
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Title.';
                        } else {
                          return null;
                        }
                      },
                    ),
                ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(70, 0, 70, 10),
                    child: TextFormField(
                      maxLength: 40,
                      decoration: InputDecoration(
                        label: Text('Targeted Muscles'),
                      ),
                      controller: muscleController,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'Enter a Targeted Muscle';
                        } else if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Enter only letters';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            TextButton(
              child: Container(
                width: 200,
                height: 47,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color(0xFF404040),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add Exercise +',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),),
              ),
              onPressed: () {
                showDialog(context: context, builder: (context) =>
                    AlertDialog(
                      title: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text('Add Exercise', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          SizedBox(width: 5,),
                          Icon(Icons.add),
                        ],
                      ),
                      content: Form(
                        key: dialogKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if(value!.isEmpty) {
                                  return 'Enter a name.';
                                } else {
                                return null;
                              }
                            },
                              maxLength: 24,
                              decoration: InputDecoration(
                                label: Text('Name'),
                              ),
                              controller: nameController,
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 120,
                                  child: TextFormField(
                                    validator: (value) {
                                      if(value!.isEmpty || RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                        return 'Enter a number';
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    decoration: InputDecoration(
                                      label: Text('Sets'),
                                    ),
                                    controller: setsController,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  width: 120,
                                  child: TextFormField(
                                    validator: (value) {
                                      if(value!.isEmpty || RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                        return 'Enter a number';
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      label: Text('Reps'),
                                    ),
                                    controller: repsController,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        TextButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                           Navigator.pop(context);
                           setsController.clear();
                           repsController.clear();
                           nameController.clear();
                          },
                            child: dialogButton(text: 'Cancel',),
                        ),
                        TextButton(
                          onPressed: () {
                            if (dialogKey.currentState!.validate()) {
                              try {
                                int.tryParse(setsController.text);
                                int.tryParse(repsController.text);
                              } catch(e) {
                                return print("Typing error");
                              }
                              exercises.add(Exercise(
                                  name: nameController.text.toString(),
                                  sets: int.tryParse(setsController.text)!,
                                  reps: int.tryParse(repsController.text)!,
                              ));
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.pop(context);
                              setState(() {});
                              setsController.clear();
                              repsController.clear();
                              nameController.clear();
                            }
                          },
                          child: dialogButton(text: "Add",),
                        ),
                      ],
                    ),
                );
              },
            ),
            SizedBox(height: 20,),
            Builder(
                builder: (context) {
                  if (exercises.isNotEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            'Exercise',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 50,
                          child: Text(
                            'Sets',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 50,
                          child: Text(
                            'Reps',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 50,
                          child: Text(''),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
            }),
            SizedBox(height: 10,),
            Expanded(
              child: Builder(
                  builder: (context) {
                    if (exercises.isEmpty) {
                      return Center(child: Text(""));
                    }
                    return ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        var sets = exercises[index].sets;
                        var reps = exercises[index].reps;
                        var name = exercises[index].name;

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(name),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: Text(sets.toString()),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: Text(reps.toString()),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: TextButton(onPressed: () {
                                    exercises.remove(exercises[index]);
                                    setState(() {});
                                    },
                                    child: Icon(Icons.delete, color: Colors.black, size: 17,),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5,),
                          ],
                        );
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextButton(
                onPressed: () {
                  if(exercises.isEmpty) {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Insert at least 1 Exercise!')));
                  } else if (formKey.currentState!.validate()) {
                    _insertPlan(titleController.text.toString(), muscleController.text.toString(), exercises);
                  }
                },
                child: Container(
                  width: 200,
                  height: 47,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xFF404040),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Save Workout Plan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertPlan(String title, String muscle, List<Exercise> exercises) async {
    var _id = M.ObjectId();
    final data = PlanModel(id: _id, muscles: muscle, title: title, status: false, exercises: exercises);
    await MongoDatabase.insertPlan(data);
    titleController.clear();
    muscleController.clear();
    Navigator.pop(context);
    setState(() {});
  }

}


