import 'package:app/models/planmodel.dart';
import 'package:flutter/material.dart';

Widget buildDataTable( List<Exercise> exercises ) {
  final columns = ["Exercise", "Sets", "Reps"];

  if(exercises==null) {
    return Text("");
  }

  return DataTable(
    columns: getColumns(columns),
    rows: getRows(exercises),
  );
}

List<DataRow> getRows(List<Exercise> rows) => rows.map((Exercise row) {
  var sets = row.sets.toString();
  var reps = row.reps.toString();
  var exercise = row.name.toString();
  final cells = [exercise, sets, reps];
  return DataRow(cells: getCells(cells));
}).toList();

List<DataCell> getCells(List<dynamic> cells) =>
    cells.map((data) => DataCell(Text('$data'))).toList();

List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(label: Text(column)))
    .toList();
