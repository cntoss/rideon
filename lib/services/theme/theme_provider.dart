import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideon/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider extends ChangeNotifier{
  ThemeProvider(){
    checkTheme();
  }


  ThemeData theme = Constant.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  void setTheme(value, c) {
    theme = value;
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("theme", c).then((val){
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: c == "dark" ? Constant.darkPrimary : Constant.lightPrimary,
          statusBarIconBrightness: c == "dark" ? Brightness.light:Brightness.dark,
        ));
      });
    });
    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  Future<ThemeData> checkTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeData theme;
    String current = prefs.getString("theme") == null ? "light" : prefs.getString(
        "theme");

    if(current == "light"){
      theme = Constant.lightTheme;
      setTheme(Constant.lightTheme, "light");
    }else{
      theme = Constant.darkTheme;
      setTheme(Constant.darkTheme, "dark");
    }

    return theme;
  }
}