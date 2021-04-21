import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/screens/login/loginPage.dart';
import 'package:rideon/screens/login/registerscreen.dart';
import 'package:rideon/widgets/appButton.dart';
import 'package:rideon/services/firebase/firebaseService.dart';

class InitialLandingPage extends StatefulWidget {
  @override
  _InitialLandingPageState createState() => _InitialLandingPageState();
}

class _InitialLandingPageState extends State<InitialLandingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getss();
  }

  getss() async {
    var token = await FirebaseService().getFirebaseToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset(
            'assets/rideon.png',
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
            //color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffffffff),
                Color(0xfffffbff),
                Color(0xfffffbfa),
                Color(0xfffafbf8),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Welcome to ride on', style: title),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton().appButton(
                        text: 'Get Started',
                        color: Colors.red,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
                              ));
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          },
                          child: Text('Login'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 12,
        //color: Color(0xfff2ffc7),
        decoration: BoxDecoration(
          color: Color(0xfff2ffc7),
        ),
        // color: Colors.yellowAccent,
        child: Center(
          child: RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                text: 'Or Drive with ',
              ),
              TextSpan(text: 'Ride on', style: TextStyle(color: Colors.blue))
            ]),
          ),
        ),
      )),
    );
  }
}
