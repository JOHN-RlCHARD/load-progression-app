import 'package:app/widgets/dataTable.dart';
import 'package:app/widgets/dialogButton.dart';
import 'package:flutter/material.dart';

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
  late List<String> exercises = [];

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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text("Add Plan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
              child: TextField(
                maxLength: 14,
                autofocus: true,
                decoration: InputDecoration(hintText: 'Title',),
                controller: titleController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
              child: TextField(
                maxLength: 14,
                autofocus: true,
                decoration: InputDecoration(hintText: 'Targeted Muscles'),
                controller: muscleController,
              ),
            ),
            Expanded(
              child: Builder(
                  builder: (context) {
                    if (exercises.isEmpty) {
                      return Center(child: Text("No data"));
                    }
                    return ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        var split = exercises[index].split("-");
                        var sets = split[0];
                        var reps = split[1];
                        var name = split[2];
                        return Row(
                          children: [
                            Text(name),
                            Text(sets),
                            Text(reps),
                          ],
                        );
                      },
                    );
                  }),
            ),
            TextButton(
              child: Text("+ Add Exercise"),
              onPressed: () {
              showDialog(context: context, builder: (context) =>
                  AlertDialog(
                    title: Text("Add Exercise"),
                    content: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: 'name'),
                          controller: nameController,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: 'reps'),
                          controller: repsController,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: 'sets'),
                          controller: setsController,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () {
                        exercises.add(setsController.text.toString()+"-"+
                            repsController.text.toString()+"-"+
                            nameController.text.toString());
                        Navigator.pop(context);
                        _clearAll;
                        setState(() {});
                      },
                        child: dialogButton(text: "Add",),),
                    ],
                  ));
            },),
          ],
        ),
      ),
    );
  }
  void _clearAll() {
    setsController.clear();
    repsController.clear();
    nameController.clear();
  }
}


