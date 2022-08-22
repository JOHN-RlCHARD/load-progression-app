import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressionPage extends StatefulWidget {
  const ProgressionPage({Key? key}) : super(key: key);

  @override
  State<ProgressionPage> createState() => _ProgressionPageState();
}

class _ProgressionPageState extends State<ProgressionPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Progression', style: TextStyle(fontSize: 30),),);
  }
}
