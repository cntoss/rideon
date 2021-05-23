import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/screens/login/loginPage.dart';
import 'package:rideon/services/helper/hiveService.dart';

class UserService {
  Box _box = HiveService().getHiveBox();

  void addUser({@required User user}) {
    _box.put(hkUser, user);
    //todo: update after mobile number verify
    setLogin(setLoginTo: true);
  }

  void removeUser() {
    //setLogin(setLoginTo: false);
    Navigator.pushAndRemoveUntil(
        AppConfig.navigatorKey.currentState.overlay.context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);

    print('Removing User');
    //_box.delete(hkUser);
    _box.clear();
  }

  User getUser() {
    return _box.get(hkUser, defaultValue: User(id: null));
  }

  void setLogin({bool setLoginTo = false}) {
    _box.put(hkIsLoging, setLoginTo);
  }

  bool get isLogin => _box.get(hkIsLoging, defaultValue: false);

  void setIsWorkThrough({bool setWorkThrough = false}) {
    _box.put(hkIsWorkThrough, setWorkThrough);
  }

  bool get isWorkThrough => _box.get(hkIsWorkThrough, defaultValue: false);
}
