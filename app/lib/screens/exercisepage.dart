import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../models/exerciseModel.dart';
import '../dbHelper/mongodb.dart';

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
                padding: const EdgeInsets.only( left: 25),
                child: Text('Saved Exercises', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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
                  ),
                ],
                color: Color(0xFF404040),
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white,),
                onPressed: () {
                  addExercise();
                },
              )
            ),
          )
        ],
      ),
    );
  }
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
              IconButton(onPressed: () {
                titlecontroller.text = data.name;
                musclecontroller.text = data.muscle;
                desccontroller.text = data.desc!;
                showDialog(context: context, builder: (context) =>
                AlertDialog(
                  title: Text('Edit', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  content: Container(
                    child: Wrap(
                      children: [
                        TextField(
                          maxLength: 14,
                          autofocus: true,
                          decoration: InputDecoration(hintText: 'Title'),
                          controller: titlecontroller,
                        ),
                        TextField(
                          maxLength: 14,
                          autofocus: true,
                          decoration: InputDecoration(hintText: 'Targeted Muscle'),
                          controller: musclecontroller,
                        ),
                        TextField(
                          maxLength: 100,
                          minLines: 1,
                          maxLines: 3,
                          autofocus: true,
                          decoration: InputDecoration(hintText: 'Description(optional)'),
                          controller: desccontroller,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearAll();
                      },
                      child: Text('Cancel'),
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
                      child: Text('Save'),),
                  ],
                ));
                }, icon: Icon(Icons.edit), iconSize: 25,),
              SizedBox(width: 3,),
              IconButton(onPressed: () async {
                showDialog(
                    context: context, builder: (context) =>
                    AlertDialog(
                      title: Text('Warning!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      content:  Text('Procede to delete exercise ${data.name}?'),
                      actions: [
                        TextButton(onPressed: () { Navigator.pop(context); }, child: Text('No'),),
                        TextButton(onPressed: () async {
                          await MongoDatabase.deleteExercise(data);
                          Navigator.pop(context);
                          setState(() {});
                          }, child: Text('Yes'),),
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
  Future addExercise() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Exercise', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      content: Container(
        child: Wrap(
          children: [
            TextField(
              maxLength: 14,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Title'),
              controller: titlecontroller,
            ),
            TextField(
              maxLength: 14,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Targeted Muscle'),
              controller: musclecontroller,
            ),
            TextField(
              maxLength: 100,
              minLines: 1,
              maxLines: 3,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Description(optional)'),
              controller: desccontroller,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _clearAll();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await _insertExercise(
              titlecontroller.text.toString(),
              musclecontroller.text.toString(),
              desccontroller.text);
            setState(() {});
          },
          child: Text('Salvar'),),
      ],
    ),
  );
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Done!')));
    _clearAll();
    Navigator.pop(context);
  }
  void _clearAll() {
    titlecontroller.clear();
    desccontroller.clear();
    musclecontroller.clear();
  }
}
