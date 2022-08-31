import 'package:flutter/material.dart';

class MyInputTheme {
  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: color,
        width: 1.0,
      ),
    );
  }

  TextStyle _buildTextStyle(Color color) {
    return TextStyle(
      color: color,
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
    contentPadding: EdgeInsets.all(16),
    isDense: true,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    enabledBorder: _buildBorder(Color(0xFF404040)),
    errorBorder: _buildBorder(Colors.red),
    focusedBorder: _buildBorder(Colors.blueGrey),
    border: _buildBorder(Colors.yellow),
    disabledBorder: _buildBorder(Colors.grey[400]!),

    suffixStyle: _buildTextStyle(Colors.black),
    counterStyle: _buildTextStyle(Colors.black),
    floatingLabelStyle: _buildTextStyle(Colors.black),
    errorStyle: _buildTextStyle(Colors.red),
    helperStyle: _buildTextStyle(Colors.cyan),
    hintStyle: _buildTextStyle(Colors.grey),
    labelStyle: _buildTextStyle(Colors.black),
    prefixStyle: _buildTextStyle(Colors.black),

  );
}