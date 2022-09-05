import 'package:app/widgets/dialogButton.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dbHelper/mongodb.dart';
import '../models/planmodel.dart';
import '../widgets/addWorkoutPlan.dart';
import '../widgets/dataTable.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {

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
                      onPressed: () {
                        Navigator.push( context,
                          MaterialPageRoute(
                              builder: (context) => AddWorkoutPlan()),); }
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
        child: ExpandableNotifier(
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
                tapBodyToCollapse: false,
                tapBodyToExpand: true,
            ),
            header: Row(
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
              IconButton(onPressed: () async {
                showDialog(context: context, builder: (context) => AlertDialog(
                  title: Text("Warning!"),
                  content: Text("Procede to delete workout ${data.title}?"),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                      }, child: dialogButton(text: 'Cancel',)),
                    TextButton(onPressed: () async {
                      await MongoDatabase.deletePlan(data);
                      Navigator.pop(context);
                      setState(() {});
                      }, child: dialogButton(text: 'Delete',)),
                  ],
                ));
                }, icon: Icon(Icons.delete), iconSize: 25,),
              ],
            ),
            collapsed: Text("Targeted muscles: "+data.muscles, style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis,),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Targeted muscles: "+data.muscles, style: TextStyle(fontSize: 16),),
                buildDataTable(data.exercises),
              ],
            ),
          ),
        ),
      );
  }
}



