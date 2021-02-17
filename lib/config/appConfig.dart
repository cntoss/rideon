
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Declare globals that are used frequently in application
class AppConfig {
  /// Manage navigator state from anywhere such as show dialog, push or pop route etc.
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); //date diplay style
   
  DateFormat dateWithTime = DateFormat('MMM dd, yyyy   hh:mm a');
 }
 const hiveBoxName = 'rideOnBox';
 
const hkEncryptionKey = "hkKey";
const hkUser = 'user';
const hkIsAppInitialized = 'isappinitialized';
const hkIsWorkThrough = 'isWorkThrough';
const hkAddressType = 'addressType';