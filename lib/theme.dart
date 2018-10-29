import 'package:flutter/material.dart';

class HarpyTheme {
  static TextTheme _textTheme =
      ThemeData.light().textTheme.apply(fontFamily: "OpenSans");

  static ThemeData get theme {
    return ThemeData.light().copyWith(
      primaryColor: Colors.indigo,
      buttonColor: Colors.white,

      // text
      textTheme: _textTheme.copyWith(
        title: _textTheme.title.copyWith(
          fontSize: 48.0,
          letterSpacing: 6.0,
          color: Colors.white,
          fontFamily: "Comfortaa",
          fontWeight: FontWeight.w300,
        ),
        button: _textTheme.button.copyWith(
          color: Colors.indigo,
        ),
      ),
    );
  }
}
