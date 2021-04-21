import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/notification/notification.dart';

import 'notification_service.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void initFirebase() {
    _firebaseMessaging.configure(onMessage: (dynamic message) async {
      print(message);
      _showNotificationDialog(message);
      _saveNotification(message);
    }, onLaunch: (dynamic message) async {
      _showNotificationDialog(message, isBackground: true);
      _saveNotification(message);
    }, onResume: (dynamic message) async {
      _showNotificationDialog(message, isBackground: true);
      _saveNotification(message);
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    _firebaseMessaging.subscribeToTopic("all");
  }

  void _showNotificationDialog(dynamic message, {bool isBackground = false}) {
    String title;
    String content;

    if (Platform.isIOS) {
      title =
          !isBackground ? message['aps']['alert']["title"] : message["title"];

      content =
          !isBackground ? message['aps']['alert']["body"] : message['message'];
    } else {
      title = !isBackground
          ? message["notification"]["title"]
          : message["data"]["title"];
      content = !isBackground
          ? message["notification"]["body"]
          : message['data']['message'];
    }

    showDialog(
        barrierDismissible: false,
        context: AppConfig.navigatorKey.currentState.context,
        builder: (context) {
          return AlertDialog(
            title: Text(title ?? ' '),
            content: Text(content ?? ' '),
            actionsPadding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 2 - 50 * 2),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  child: Text('OK',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }

  void _saveNotification(dynamic message) {
    if (Platform.isIOS) {
      if (message["type"] != "news")
        NotificationService().saveNotification(OfflineNotification(
            title: message["title"],
            description: message["message"],
            date: DateTime.now()));
    } else {
      if (message["data"]["type"] != "news")
        NotificationService().saveNotification(OfflineNotification(
            title: message["data"]["title"],
            description: message["data"]["message"],
            image: message["data"]["image"],
            link: message["data"]["link"],
            date: DateTime.now()));
    }
  }

  Future<String> getFirebaseToken() {
    Future<String> firebaseToken =
        _firebaseMessaging.getToken().then((value) => value);
    return firebaseToken;
  }
}
