import 'dart:developer';
import 'package:app/dbHelper/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDatabase {
  static var db;

  static connect() async {
    db = await Db.create(MONGO_CONNECTION_URL);
    await db.open();
  }

  static getExercises() async {
    final arrData = await db.collection("exercises").find().toList();
    return arrData;
  }
}