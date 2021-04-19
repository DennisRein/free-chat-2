import 'package:flutter/material.dart';

class HomeTheme {
  HomeTheme();

  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: Color.fromRGBO(64,107, 199, 1),
      fontFamily: "PTSans",
      textButtonTheme: TextButtonThemeData(
        //64, 107, 199
        style: TextButton.styleFrom(
            textStyle: TextStyle(
              fontFamily: "PTSans"
            ),
            primary: Color.fromRGBO(64,107, 199, 1)
        ),
      ),
    );
  }
}