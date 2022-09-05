import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
  PlanModel({
    required this.id,
    required this.muscles,
    required this.title,
    required this.status,
    required this.exercises,
  });

  ObjectId id;
  String muscles;
  String title;
  bool status;
  List<Exercise> exercises;

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    id: json["_id"],
    muscles: json["muscles"],
    title: json["title"],
    status: json["status"],
    exercises: List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "muscles": muscles,
    "title": title,
    "status": status,
    "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
  };
}

class Exercise {
  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
  });

  String name;
  int sets;
  int reps;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json["name"],
    sets: json["sets"],
    reps: json["reps"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "sets": sets,
    "reps": reps,
  };
}

