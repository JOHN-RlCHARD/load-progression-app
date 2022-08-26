import 'package:flutter/material.dart';

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
