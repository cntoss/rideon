import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/screens/login/loginPage.dart';
import 'package:rideon/screens/login/registerscreen.dart';
import 'package:rideon/screens/widgets/appButton.dart';

class InitialLandingPage extends StatelessWidget {
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
                Text('Welcome to ride on', style: Constant.titleBig),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(flex: 1),
                      AppButton().appButton(
                          small: true,
                          text: 'Sign In',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          },
                          color: Colors.tealAccent),
                      Spacer(flex: 10),
                      AppButton().appButton(
                        small: true,
                        text: 'Register',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
                              ));
                        },
                      ),
                      Spacer(flex: 1),
                      /*  CustomDialog().dialogButton(
                          text: 'Register', onPressed: () {
                             Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registration(),
                            ));
                          }) */
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
