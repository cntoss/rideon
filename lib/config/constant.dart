import 'package:flutter/material.dart';

class Constant {
  static ButtonStyle buttonStyle = TextButton.styleFrom(
      textStyle: TextStyle(fontSize: 14, letterSpacing: 1, wordSpacing: 1));

  static OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(10));

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightBG,
    accentColor: lightAccent,
    textSelectionTheme: TextSelectionThemeData(cursorColor: lightAccent),
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    //fontFamily: GoogleFonts.roboto().fontFamily,
    backgroundColor: darkBG,
    primaryColor: darkBG,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    textSelectionTheme: TextSelectionThemeData(cursorColor: darkAccent),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    ),
  );
}

const phoneValidationError = "Phone number must have exactly 10 digits ";
const defaultloginError =
    'Woopsie! Login Failed, please retry in a minute or so.';
const otpEmptyError = "OTP must be 6 digit number";

const stackfoldBackground = Color(0xfff5ead7);
const lightAccent = Color(0xffFFEE58);
const darkAccent = Color(0xff11998e);
const lightBG = Color(0xffffffff);
const darkBG = Colors.black;
const textColor = Colors.black45;
const textFormColor = Color(0xffffcf2d8);
const cardColor = Color(0xfffefaf0);

const errorStyle = TextStyle(color: Colors.redAccent, fontSize: 16);
const normalText = TextStyle(color: textColor, fontSize: 16);

const title = const TextStyle(
    inherit: false,
    color: Color(0x8a000000),
    fontFamily: "Poppins",
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none);

const subTitle = const TextStyle(
    inherit: false,
    color: Color(0x8a000000),
    fontFamily: "Poppins",
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none);

const bottonStyle =
    const TextStyle(inherit: false, color: Colors.white, fontSize: 16);

const bottonPadding = EdgeInsets.all(12.0);
