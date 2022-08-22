import 'package:app/models/exerciseModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDatabase {
  static var db;

  static connect() async {
    db = await Db.create(MONGO_CONNECTION_URL);
    await db.open();
  }

  static Future<String> insertExercise(ExerciseModel data) async {
    try {
      var result = await db.collection("exercises").insertOne(data.toJson());
      if (result.isSucces) {
        return "Data Inserted";
      } else {
        return "Something went wrong";
      }
    } catch(e) {
      print(e.toString());
      return e.toString();
    }
  }

  static getExercises() async {
    final arrData = await db.collection("exercises").find().toList();
    return arrData;
  }
}