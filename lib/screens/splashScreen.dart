import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideon/screens/login/initialLandingPage.dart';
import 'package:rideon/services/helper/userService.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

   Future.delayed(Duration(seconds: 1)).then((value) {
SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    UserService().setIsWorkThrough();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialLandingPage(),
          ));
   });
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Image.asset(
          "assets/rideon.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
      ),
      /* body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ride on' ,
          style: TextStyle(color: Colors.yellow, fontSize: 40,),
        ),
      ),
    ) */
    );
  }
}
