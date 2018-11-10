import 'package:flutter/material.dart';

class HarpyTheme {
  static TextTheme _textTheme =
      ThemeData.light().textTheme.apply(fontFamily: "OpenSans");

  static const Color primaryColor = Colors.indigo;

  static ThemeData get theme {
    return ThemeData.light().copyWith(
      primaryColor: primaryColor,
      accentColor: Colors.indigoAccent,
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
            color: primaryColor,
          ),

          // default text
          body1: _textTheme.body1.copyWith(
            fontSize: 14.0,
          ),

          // username
          caption: _textTheme.caption.copyWith(
            fontSize: 12.0,
          )),
    );
  }
}
