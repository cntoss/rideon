import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rideon/common/theme.dart';
import 'package:rideon/models/pooling/counterModel.dart';
import 'package:rideon/screens/home/homePageWarper.dart';
import 'package:rideon/screens/login/loginwrapper.dart';
import 'package:rideon/screens/splash/splash.dart';
import 'package:rideon/services/connectivity/connectivity_service.dart';
import 'package:rideon/services/helper/hiveService.dart';
import 'package:rideon/services/helper/userService.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:rideon/services/theme/theme_provider.dart';
import 'package:rideon/services/utils/uiModifiers.dart';
import 'package:flutter/cupertino.dart';

import 'config/appConfig.dart';
import 'models/connectivity/connectivity_status.dart';
import 'services/firebase/firebaseService.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseService().initFirebase();
  Firebase.initializeApp();

  ///todo: remove if status bar is default transparent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await HiveService().initHive();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => PassengerCounter(),
        ),
        Provider(
          create: (_) => LoginManger(),
        )
      ],
      child: ScrollConfiguration(behavior: NoGlow(), child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      create: (context) =>
          ConnectivityService().connectionStatusController.stream,
          child: MaterialApp(
      navigatorKey: AppConfig.navigatorKey,
      title: 'Ride On',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      //home: LoginPage(),
      //home: UserService().isLogin ? HomePageWrapper() : SplashScreen(),

      initialRoute: UserService().isLogin ? '/login' : '/splash',
      //initialRoute: '/splash',
      routes: {
        // '/': (context) => SplashScreen(),
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginWrapper(),
        '/home': (context) => HomePageWrapper(),
      },
    ),);
  }
}
