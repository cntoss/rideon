import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/screens/login/loginPage.dart';

import 'package:rideon/services/helper/userService.dart';

enum LoginStates { loggedIn, loggedOut, loading, error }

class LoginManger {
  ValueNotifier<LoginStates> _notifier;
  String _errorMessage;

  String get errorText => _errorMessage;

  ValueNotifier<LoginStates> get currentState {
    LoginStates state;
    if (UserService().isLogin)
      state = LoginStates.loggedIn;
    else
      state = LoginStates.loggedOut;
    _notifier ??= ValueNotifier(state);
    return _notifier;
  }

  login({@required String phone, @required String password}) async {
    var result;
    _notifier.value = LoginStates.loading;
    await Future.delayed(Duration(seconds: 3), () {
      // todo : hit login ko api
      result = true;
    });
    if (result == null) {
      UserService().setLogin(setLoginTo: false);
      //todo string lai const ma lagne
      _errorMessage = "Default Error Message";
      _notifier.value = LoginStates.error;
      Future.delayed(Duration(seconds: 3), () {
        _notifier.value = LoginStates.loggedOut;
      });
    } else if (result is String) {
      _errorMessage = result;
      _notifier.value = LoginStates.error;
      Future.delayed(Duration(seconds: 3), () {
        _notifier.value = LoginStates.loggedOut;
      });
    } else {
      UserService().setLogin();
      //UserService().addUser(user: user);//todo:login
      _notifier.value = LoginStates.loggedIn;
    }
  }

  Future<bool> register(User user) async {
    var result;
    _notifier.value = LoginStates.loading;
    await Future.delayed(Duration(seconds: 3), () {
      // todo : hit login ko api
      result = true;
    });
    if (result == null) {
      UserService().setLogin(setLoginTo: false);
      //todo string lai const ma lagne
      _errorMessage = "Default Error Message";
      _notifier.value = LoginStates.error;
      Future.delayed(Duration(seconds: 3), () {
        _notifier.value = LoginStates.loggedOut;
      });
      return false;
    } else if (result is String) {
      _errorMessage = result;
      _notifier.value = LoginStates.error;
      Future.delayed(Duration(seconds: 3), () {
        _notifier.value = LoginStates.loggedOut;
      });
      return false;
    } else {
      UserService().setLogin();
      UserService().addUser(user: user); //todo:login
      _notifier.value = LoginStates.loggedIn;
      return true;
    }
  }

  logout(Function() onError) async {
    var result;
    await Future.delayed(Duration(seconds: 0), () {
      //todo hit logout ko api
      result = true;
    });
    if (result == null || result is String) {
      //todo error huda error dekhaune
      onError();
    } else {
      UserService().setLogin(setLoginTo: false);
      //todo clear app data
      _notifier.value = LoginStates.loggedOut;
      Navigator.pushReplacement(
          AppConfig.navigatorKey.currentContext,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    }
  }
}
