import 'package:app/dbHelper/mongodb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dbHelper/MongoDbModel.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
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
                  print('Total Data = '+totalData.toString());
                  return ListView.builder(
                    itemCount: totalData,
                    itemBuilder: (context, index) {
                      return exerciseCard(
                        MongoDbModel.fromJson(snapshot.data[index])
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
    );
  }
  Widget exerciseCard(MongoDbModel data) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("${data.id}"),
            SizedBox( height: 5,),
            Text("${data.name}"),
            SizedBox( height: 5,),
            Text("${data.muscle}"),
          ],
        ),
      ),
    );
  }
}
