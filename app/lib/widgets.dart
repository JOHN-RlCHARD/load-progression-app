import 'package:flutter/material.dart';

class AddEditExerciseDialog extends StatelessWidget {
  final TextEditingController titlecontroller;
  final TextEditingController musclecontroller;
  final TextEditingController desccontroller;
  final List<Widget> actions;
  final String title;
  final Icon icon;

  const AddEditExerciseDialog({Key? key, required this.titlecontroller, required this.musclecontroller, required this.desccontroller, required this.actions, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          SizedBox(width: 5,),
          icon,
        ],
      ),
      content: Container(
        child: Wrap(
          children: [
            TextField(
              maxLength: 14,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Title',),
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
      actionsAlignment: MainAxisAlignment.center,
      actions: actions,
    );
  }
}

