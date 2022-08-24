import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';

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
  List<String> exercises;

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    id: json["_id"],
    muscles: json["muscles"],
    title: json["title"],
    status: json["status"],
    exercises: List<String>.from(json["exercises"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "muscles": muscles,
    "title": title,
    "status": status,
    "exercises": List<dynamic>.from(exercises.map((x) => x)),
  };
}
