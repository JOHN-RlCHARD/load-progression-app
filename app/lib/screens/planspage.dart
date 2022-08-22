import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Plans', style: TextStyle(fontSize: 30),),);
  }
}
