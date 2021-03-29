import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constant {
  static Color stackfoldBackground = Color(0xfff5ead7);

  static String passwordValidationError =
      "Password must contain at least 6 characters.";
  static String phoneValidationError =
      "Phone number must have exactly 10 digits ";
  static String defaultloginError =
      'Woopsie! Login Failed, please retry in a minute or so.';

  static Color lightPrimary = Color(0xffffffff);
  static Color darkPrimary = Colors.black;
  static List<Color> get tileGradient =>
      [lightAccent, lightAccentComplimentary];
  static Color lightAccent = Color(0xffFFEE58);
  static Color lightAccentComplimentary = Color(0xffFFaa58);
  static Color darkAccent = Color(0xff11998e);
  static Color lightBG = Color(0xffffffff);
  static Color darkBG = Colors.black;
  static Color textColor = Colors.black45;
  static Color textFormColor = Color(0xffffcf2d8);
  static Color cardColor = Color(0xfffefaf0);
  static TextStyle errorStyle =
      TextStyle(color: Colors.redAccent, fontSize: 16);
  static TextStyle whiteText =
      TextStyle(color: Constant.textColor, fontSize: 16);
  static TextStyle normalText =
      TextStyle(color: Constant.textColor, fontSize: 16);

  static TextStyle title = const TextStyle(
      inherit: false,
      color: Color(0x8a000000),
      fontFamily: "Roboto",
      fontSize: 28.0,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none);

  static TextStyle titleBig = const TextStyle(
      inherit: false,
      color: Colors.black45,
      fontFamily: "Roboto",
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(10));

  static TextStyle titleWhite = const TextStyle(
      inherit: false,
      color: Colors.black,
      fontFamily: "Roboto",
      fontSize: 28.0,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none);

  static TextStyle bottonStyle =
      const TextStyle(inherit: false, color: Colors.black, fontSize: 16);
  static EdgeInsetsGeometry bottonPadding = EdgeInsets.all(12.0);
  static ThemeData lightTheme = ThemeData(
    //fontFamily: GoogleFonts.roboto().fontFamily,
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
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
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    //fontFamily: GoogleFonts.roboto().fontFamily,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
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

  static ButtonStyle buttonStyle = TextButton.styleFrom(
      textStyle: TextStyle(fontSize: 14, letterSpacing: 1, wordSpacing: 1));
}
