import 'package:flutter/material.dart';

class CustomDatePicker {
  Future<DateTime> selectDate(
      BuildContext context, DateTime selectedDate, {bool fromCarPooling = true}) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate != null ? selectedDate : DateTime.now(),
        firstDate: fromCarPooling ? DateTime.now() : DateTime(1910),
        lastDate: fromCarPooling ? DateTime.now().add(Duration(days: 30)) : DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                //primary: Colors.tealAccent,
                onPrimary: Colors.white,
                surface: Colors.redAccent,
                onSurface: Colors.black45,
              ),
              //this fill color of textfield on edit
              /*  inputDecorationTheme: InputDecorationTheme(
                fillColor: Colors.redAccent,
                filled: true,
              ), */
              textTheme: TextTheme(
                bodyText2: TextStyle(
                  color: Colors.blue,
                ),
                subtitle1: TextStyle(color: Colors.black),
              ),
              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: child,
          );
        });

    return newSelectedDate;
  }
}
