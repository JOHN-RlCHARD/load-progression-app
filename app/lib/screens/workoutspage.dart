import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dbHelper/mongodb.dart';
import '../models/planmodel.dart';
import '../widgets.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
                  child: Row(
                    children: [
                      Text(
                        'Your Workout Plans',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Spacer(),
                      IconButton(
                        onPressed: () {setState(() {});},
                        icon: Icon(Icons.refresh),)
                    ],
                  ),
                ),

                Expanded(
                  child: FutureBuilder(
                    future: MongoDatabase.getPlans(),
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
                              return planCard(PlanModel.fromJson(snapshot.data[index]));
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

            // FloatingActionButton to add new Plan.
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
                      onPressed: () {}
                  )
              ),
            ),
          ],
        )
    );
  }

  Widget planCard(PlanModel data) {
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
                  "${data.title}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),

              // EDIT BUTTON
              IconButton(onPressed: () {}, icon: Icon(Icons.edit), iconSize: 25,),
              SizedBox(width: 3,),

              // DELETE BUTTON
              IconButton(onPressed: () async {}, icon: Icon(Icons.delete), iconSize: 25,),
            ],
          ),
          Text("Targeted muscles: "+data.muscles, style: TextStyle(fontSize: 16),),

          buildDataTable(data.exercises),
          
        ],
      ),
    );
  }
  
  Widget buildDataTable( List<String> exercises ) {
    final columns = ["Sets", "Reps", "Exercise"];
    
    return DataTable(
        columns: getColumns(columns),
        rows: getRows(exercises),
    );
  }

  List<DataRow> getRows(List<String> rows) => rows.map((String row) {
    var split = row.split("-");
    var sets = split[0];
    var reps = split[1];
    var exercise = split[2];
    final cells = [sets, reps, exercise];
    return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
  cells.map((data) => DataCell(Text('$data'))).toList();

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(label: Text(column)))
      .toList();
  
  void _clearAll(){

  }
}



