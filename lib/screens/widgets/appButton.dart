import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
class AppButton{

Widget appButton(
      {@required String text,
      @required Function() onTap,
      bool small = false,
      Color color}) {
    return MaterialButton(
      elevation: 1,
      focusElevation: 1,
      color: color  != null? color : Colors.blue,
      shape: StadiumBorder(),
      onPressed: () async {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: small ? 20.0 : 60.0),
        child: Text(
          text,
          style: Constant.titleWhite.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}
