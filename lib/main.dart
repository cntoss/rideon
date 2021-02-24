import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/common/theme.dart';
import 'package:rideon/models/pooling/counterModel.dart';
import 'package:rideon/screens/home/homePageWarper.dart';
import 'package:rideon/screens/login/loginPage.dart';
import 'package:rideon/screens/login/loginwrapper.dart';
import 'package:rideon/screens/splashScreen.dart';
import 'package:rideon/services/helper/hiveService.dart';
import 'package:rideon/services/helper/userService.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:rideon/services/theme/theme_provider.dart';
import 'package:rideon/services/utils/uiModifiers.dart';
import 'package:flutter/cupertino.dart';

import 'config/appConfig.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppConfig.navigatorKey,
      title: 'Ride On',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      //home: LoginPage(),
      //home: UserService().isLogin ? HomePageWrapper() : SplashScreen(),

      initialRoute: UserService().isWorkThrough ? '/login' : '/',
      //initialRoute: '/home',
      routes: {
       // '/': (context) => SplashScreen(),
        '/': (context) => HomePageWrapper(),
        '/login': (context) => LoginWrapper(),
        '/home': (context) => HomePageWrapper(),
      },
    );
  }
}
