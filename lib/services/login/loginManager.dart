import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/repository/login/login_repo.dart';
import 'package:rideon/repository/login/register_repo.dart';
import 'package:rideon/services/helper/userService.dart';

enum LoginStates { loggedIn, loggedOut, loading, error }

class LoginManger {
  late ValueNotifier<LoginStates> _notifier;
  String? _errorMessage;

  String get errorText => _errorMessage!;

  ValueNotifier<LoginStates> get currentState {
    LoginStates state = LoginStates.loggedOut;
    if (UserService().isLogin)
      state = LoginStates.loggedIn;
    else
      state = LoginStates.loggedOut;
    // _notifier ??= ValueNotifier(state);
    //v2
    _notifier = ValueNotifier(state);
    return _notifier;
  }

/*   login({@required String phone}) async {
    var result;
    _notifier.value = LoginStates.loading;
    result = LoginRequest().loginRequest(phone);
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
      UserService().setLogin(setLoginTo: true);
      //UserService().addUser(user: user);//todo:login
      _notifier.value = LoginStates.loggedIn;
    }
  } */

  Future<bool> login({required String phone}) async {
    LoginResponse? result = await LoginRequest().loginRequest(phone);
    if (result == null) {
      return false;
    } else if (!result.valid!) {
      //V2
      return false;
    } else {
      UserService().setLogin(setLoginTo: true);
      return true;
    }
  }

  Future<bool> register(User user) async {
    var result;
    _notifier.value = LoginStates.loading;
    //LoginResponse result = await RegisterRequest().registerRequest(user);

    if (result == null) {
      UserService().setLogin(setLoginTo: false);
      //todo string lai const ma lagne
      _errorMessage = "Default Error Message";
      _notifier.value = LoginStates.error;
      Future.delayed(Duration(seconds: 3), () {
        _notifier.value = LoginStates.loggedOut;
      });
      return false;
    } else if (!result.valid) {
      _errorMessage = result;
      _notifier.value = LoginStates.error;
      Future.delayed(Duration(seconds: 3), () {
        _notifier.value = LoginStates.loggedOut;
      });
      return false;
    } else {
      UserService().setLogin(setLoginTo: true);
      UserService().addUser(user: user);
      _notifier.value = LoginStates.loggedIn;
      return true;
    }
  }

  logout(Function() onError) async {
    var result;
    await Future.delayed(Duration(seconds: 1), () {
      //todo hit logout ko api
      result = true;
    });
    if (result == null || result is String) {
      //todo error huda error dekhaune
      onError();
    } else {
      //todo clear app data
      //_notifier.value = LoginStates.loggedOut;
      UserService().removeUser();
    }
  }
}
