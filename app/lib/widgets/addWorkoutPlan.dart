import 'package:flutter/material.dart';

import 'dialogButton.dart';

class AddWorkoutPlan extends StatefulWidget {

  late List<String>? exerciseList = [];
  final String title;
  final Icon icon;
  final TextEditingController titlecontroller;
  final TextEditingController musclecontroller;

  AddWorkoutPlan({Key? key, required this.title, required this.icon, required this.titlecontroller, required this.musclecontroller, this.exerciseList}) : super(key: key);

  @override
  State<AddWorkoutPlan> createState() => _AddWorkoutPlanState();
}

class _AddWorkoutPlanState extends State<AddWorkoutPlan> {
  late TextEditingController exerciseName;
  late TextEditingController exerciseSets;
  late TextEditingController exerciseReps;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(widget.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          SizedBox(width: 5,),
          widget.icon,
        ],
      ),
      content: Container(
        child: Wrap(
          children: [
            TextField(
              maxLength: 14,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Title',),
              controller: widget.titlecontroller,
            ),
            TextField(
              maxLength: 14,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Targeted Muscle'),
              controller: widget.musclecontroller,
            ),
            Text('Exercises'),
            FutureBuilder(
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: widget.exerciseList?.length,
                    itemBuilder: (context, index) {
                      if (widget.exerciseList?.length==0) {
                        return Text('no data');
                      }
                      return Text(snapshot.toString());
                    });
                }),
            TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) =>
                  AlertDialog(
                    content: Column(
                      children: [
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(hintText: 'Title',),
                          controller: exerciseName,
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(hintText: 'Title',),
                          controller: exerciseSets,
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(hintText: 'Title',),
                          controller: exerciseReps,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () {
                        widget.exerciseList?.add(exerciseSets.text.toString()+"-"+exerciseReps.text.toString()+"+"+exerciseName.text.toString());
                        Navigator.pop(context);
                        setState(() {});
                        }, child: Text('send')),
                    ],
                  ));
                },
                child: dialogButton(text: '+',))
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: dialogButton(text: 'Cancel',),
        ),
        TextButton(
          onPressed: () {},
          child: dialogButton(text: 'Save',),),
      ],
    );
  }
}