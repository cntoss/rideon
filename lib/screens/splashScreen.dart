import 'package:flutter/material.dart';
import 'package:rideon/screens/login/initialLandingPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) {

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialLandingPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFEE58),
      body: Container(
        child: Image.asset(
          "assets/logo.gif",
          height: MediaQuery.of(context).size.height * 2,
          width: MediaQuery.of(context).size.width,
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
