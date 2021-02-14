import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/screens/history/historyScreen.dart';
import 'package:rideon/screens/home/customNavigationButton.dart';
import 'package:rideon/screens/home/homePage.dart';
import 'package:rideon/screens/home/homePageWarper.dart';
import 'package:rideon/screens/login/forgotPassword.dart';
import 'package:rideon/screens/setting/settingScreen.dart';
import 'package:rideon/screens/splashScreen.dart';
import 'package:rideon/screens/widgets/appButton.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:rideon/services/sharedPref.dart';
import 'package:rideon/services/theme/theme_provider.dart';
import 'package:rideon/services/utils/uiModifiers.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import 'config/appConfig.dart';
import 'package:animations/animations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(
          create: (_) => LoginManger(),
        )
      ],
      child: ScrollConfiguration(behavior: NoGlow(), child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppConfig.navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFffc8c8),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xff00B14F),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      //home: HomePageWrapper(),
      home: !LocalStorage.shouldSkipIntro
                ? SplashScreen()
                : HomePageWrapper(),
    );
  }
}

