import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

ExerciseModel exerciseModelFromJson(String str) => ExerciseModel.fromJson(json.decode(str));

String exerciseModelToJson(ExerciseModel data) => json.encode(data.toJson());

class ExerciseModel {
  ExerciseModel({
    required this.id,
    required this.name,
    required this.muscle,
    this.desc,
  });

  ObjectId id;
  String name;
  String muscle;
  String? desc;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
    id: json["_id"],
    name: json["name"],
    muscle: json["muscle"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "muscle": muscle,
    "desc": desc,
  };
}

