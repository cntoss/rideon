import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Color(0xFF3cc83c),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Color(0xff8cfaa0),
  focusColor: Colors.teal,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          textStyle:
              TextStyle(fontSize: 20, wordSpacing: 2, letterSpacing: 2))),
  /* textTheme: TextTheme(
          bodyText2:TextStyle(color: Colors.white)
        ) */
);
