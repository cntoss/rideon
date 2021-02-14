import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/screens/login/loginPage.dart';
import 'package:rideon/services/sharedPref.dart';

enum LoginStates { loggedIn, loggedOut, loading, error }

class LoginManger {
  ValueNotifier<LoginStates> _notifier;
  String _errorMessage;

  String get errorText => _errorMessage;

  ValueNotifier<LoginStates> get currentState {
    LoginStates state;
    if (LocalStorage.isLoggedIn)
      state = LoginStates.loggedIn;
    else
      state = LoginStates.loggedOut;
    _notifier ??= ValueNotifier(state);
    return _notifier;
  }

  login() async {
    var result;
    _notifier.value = LoginStates.loading;
    await Future.delayed(Duration(seconds: 3), () {
      // todo : hit login ko api
      result = true;
    });
    if (result == null) {
      LocalStorage.setLogin(setLoginTo: false);
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
      LocalStorage.setLogin();
      _notifier.value = LoginStates.loggedIn;
    }
  }

  logout(Function() onError) async {
    var result;
    await Future.delayed(Duration(seconds: 3), () {
      //todo hit logout ko api
      result = true;
    });
    if (result == null || result is String) {
      //todo error huda error dekhaune
      onError();
    } else {
      LocalStorage.setLogin(setLoginTo: false);
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
