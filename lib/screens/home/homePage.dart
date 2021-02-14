import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/screens/widgets/appButton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    super.build(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/location.JPG'),
          fit: BoxFit.fill,
        )),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: AppButton().appButton(
                color: Colors.blue,
                small: false,
                text: "Carpooling",
                onTap: () {
                  print('car pooling');
                },
              ),
            ),
            Positioned(
              top: height / 1.6,
              width: width,
              child: Card(
                child: Container(
                  height: height/3 +10,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          color: Color(0xfff0e1ee),
                          child: Container(
                            width: width,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Where to go? ',
                              style: Constant.title,
                            ),
                          )),
                      Row(
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.grey,
                            textColor: Colors.white,
                            child: Icon(
                              Icons.home,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(0),
                            shape: CircleBorder(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Home'),
                              Text('Pulchowk Lalitpur')
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: SizedBox(
                          height: 1,
                          width: width,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: Colors.grey,
                            textColor: Colors.white,
                            child: Icon(
                              Icons.star,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(0),
                            shape: CircleBorder(),
                          ),
                          Column(
                            children: [
                              Text('Choose a saved place'),
                              //Text('Pulchowk Lalitpur')
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
