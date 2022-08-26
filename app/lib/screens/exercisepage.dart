import 'package:app/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../models/exerciseModel.dart';
import '../dbHelper/mongodb.dart';
import '../widgets/dialogButton.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {

  late TextEditingController titlecontroller;
  late TextEditingController desccontroller;
  late TextEditingController musclecontroller;

  @override
  void initState() {
    super.initState();
    titlecontroller = TextEditingController();
    desccontroller = TextEditingController();
    musclecontroller = TextEditingController();
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    desccontroller.dispose();
    musclecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only( left: 25, right: 25),
                child: Row(
                  children: [
                    Text(
                      'Saved Exercises',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    Spacer(),
                    IconButton(
                      onPressed: () {setState(() {});},
                      icon: Icon(Icons.refresh),)
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Expanded(
                child: FutureBuilder(
                  future: MongoDatabase.getExercises(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        var totalData = snapshot.data.length;
                        return ListView.builder(
                          itemCount: totalData,
                          itemBuilder: (context, index) {
                            return exerciseCard(
                                ExerciseModel.fromJson(snapshot.data[index])
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                              'Nenhum dado disponivel.'
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),

          // ADD NEW EXERCISE BUTTON
          Positioned(
            bottom: 25,
            right: 25,
            child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(1,1,),
                    ),],
                  color: Color(0xFF404040),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white,),
                    onPressed: () {
                      showDialog(context: context, builder: (context) =>
                          AddEditExerciseDialog(
                            titlecontroller: titlecontroller,
                            musclecontroller: musclecontroller,
                            desccontroller: desccontroller,
                            title: 'Add Exercise',
                            icon: Icon(Icons.add),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _clearAll();
                                },
                                child: dialogButton(text: 'Cancel',),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await _insertExercise(
                                        titlecontroller.text.toString(),
                                        musclecontroller.text.toString(),
                                        desccontroller.text);
                                    setState(() {});
                                  },
                                  child: dialogButton(text: 'Save',)
                              ),
                            ],
                          )
                      );
                    }
                )
            ),
          ),
        ],
      ),
    );
  }

  // EXERCISE CARD
  Widget exerciseCard(ExerciseModel data) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 14,
        left: 10,
        right: 10
      ),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20,10,20,20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0.0,4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 160,
                child: Text(
                  "${data.name}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),

              // EDIT BUTTON
              IconButton(onPressed: () {
                titlecontroller.text = data.name;
                musclecontroller.text = data.muscle;
                desccontroller.text = data.desc ?? "";
                showDialog(context: context, builder: (context) =>
                AddEditExerciseDialog(
                  titlecontroller: titlecontroller,
                  musclecontroller: musclecontroller,
                  desccontroller: desccontroller,
                  title: 'Edit',
                  icon: Icon(Icons.edit),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearAll();
                      },
                      child: dialogButton(text: 'Cancel',),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _updateExercise(
                            data.id,
                            titlecontroller.text.toString(),
                            musclecontroller.text.toString(),
                            desccontroller.text);
                        setState(() {});
                      },
                      child: dialogButton(text: 'Save',),),
                  ],),
                );
                }, icon: Icon(Icons.edit), iconSize: 25,),
              SizedBox(width: 3,),

              // DELETE BUTTON
              IconButton(onPressed: () async {
                showDialog(
                    context: context, builder: (context) =>
                    AlertDialog(
                      title: Text('Warning!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      content:  Text('Procede to delete exercise ${data.name}?'),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        TextButton(onPressed: () { Navigator.pop(context); },
                          child: dialogButton(text: 'No',),),
                        TextButton(onPressed: () async {
                          await MongoDatabase.deleteExercise(data);
                          Navigator.pop(context);
                          setState(() {});
                          },
                          child: dialogButton(text: 'Yes',),
                        ),
                      ],
                ));
                }, icon: Icon(Icons.delete), iconSize: 25,),
            ],
          ),
          Text(data.desc ?? "No description.", style: TextStyle(fontSize: 17),),
        ],
      ),
    );
  }
  Future<void> _updateExercise(M.ObjectId id, String title, String muscle, String? desc) async {
    if (desc == "") { desc = null; }
    final updateExercise = ExerciseModel(id: id, name: title, muscle: muscle, desc: desc);
    await MongoDatabase.updateExercise(updateExercise);
    _clearAll();
    Navigator.pop(context);
  }
  Future<void> _insertExercise(String title, String muscle, String? desc) async {
    var _id = M.ObjectId();
    if (desc == "") { desc = null; }
    final data = ExerciseModel(id: _id, name: title, muscle: muscle, desc: desc);
    await MongoDatabase.insertExercise(data);
    _clearAll();
    Navigator.pop(context);
  }
  void _clearAll() {
    titlecontroller.clear();
    desccontroller.clear();
    musclecontroller.clear();
  }
}
