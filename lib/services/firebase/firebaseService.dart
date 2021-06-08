import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/models/notification/notification.dart';
import 'package:rideon/models/notification/request_notification.dart';
import 'package:rideon/screens/notification/notification.dart';
import 'package:rideon/screens/ride/request/request.dart';
import 'package:rideon/widgets/custom_dialog.dart';

import 'notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

/* const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); */

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void initFirebase() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /*  await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
 */
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.getToken().then((value) => print(value!));
    _firebaseMessaging.getInitialMessage().then((value) => print(value));
    /*  _firebaseMessaging.configure(onMessage: (dynamic message) async {
      print(message);
      _showNotificationDialog(message);
      _saveNotification(message);
    }, onLaunch: (dynamic message) async {
      _saveNotification(message);
      _openNotification(message);
    }, onResume: (dynamic message) async {
      _saveNotification(message);
      _openNotification(message);
    }); */
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? x) => print(x));

    /* FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print(message);
      }
    }); */

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print(message);

      ///TODO: appears notification dialog on app in foreground
      /*  RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      } */
      _showNotificationDialog(message);
      _saveNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //print(message);

      print('A new onMessageOpenedApp event was published!');
      _saveNotification(message);
      _openNotification(message);
    });

    _firebaseMessaging.requestPermission();
    /* _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {}); */
    _firebaseMessaging
        .subscribeToTopic("all"); //"to":"topics/all" in firebase body parameter
    _firebaseMessaging.subscribeToTopic("passenger");
  }

  void _showNotificationDialog(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      CustomDialog().showCustomDialog(
          title: notification.title,
          content: notification.body,
          actions: [
            CustomDialog().dialogButton(
              text: 'CLOSE',
              color: Colors.black12,
              onPressed: () {
                Navigator.pop(AppConfig.navigatorKey.currentState!.context);
              },
            ),
            CustomDialog().dialogButton(
              text: 'OPEN',
              onPressed: () {
                Navigator.pop(AppConfig.navigatorKey.currentState!.context);
                _openNotification(message);
              },
            ),
          ]);
    }
  }

//Notification which type is news are stored locally rest are not
  void _saveNotification(RemoteMessage message) {
    if (message.data["type"] == "news") if (message.notification != null)
      NotificationService().saveNotification(OfflineNotification(
          title: message.data["title"],
          description: message.data["message"],
          image: message.data["image"],
          link: message.data["link"],
          date: DateTime.now()));
  }

  void _openNotification(RemoteMessage message) {
    if (message.data['type'] == 'ride_request')
      Navigator.push(
        AppConfig.navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) {
            return RideRequestPage(
              notificationData: NotificationData.fromJson(message.data),
            );
          },
        ),
      );
    else
      Navigator.push(
        AppConfig.navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) {
            return NotificationScreen();
          },
        ),
      );
  }

  Future<String> getFirebaseToken() {
    Future<String> firebaseToken =
        _firebaseMessaging.getToken().then((value) => value!);
    return firebaseToken;
  }
}
