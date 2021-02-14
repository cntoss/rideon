

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static init() async {
    sp ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences sp;

  static skipIntro({bool shouldSip = true}) {
    sp.setBool("intro", shouldSip);
  }

  static bool get shouldSkipIntro => sp.getBool('intro') ?? false;

  static setLogin({bool setLoginTo = true}) {
    sp.setBool("login", setLoginTo);
  }

  static bool get isLoggedIn => sp.getBool('login') ?? false;


}
