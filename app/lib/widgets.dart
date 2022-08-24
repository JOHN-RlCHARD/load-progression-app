import 'package:flutter/material.dart';

class dialogButton extends StatelessWidget {
  final String text;

  const dialogButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 47,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xFF404040),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20),),
    );
  }
}

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


