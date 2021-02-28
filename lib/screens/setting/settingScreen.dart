import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/screens/profile/profileScreen.dart';
import 'package:rideon/screens/setting/savedAddress.dart';
import 'package:rideon/services/helper/userService.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:rideon/services/utils/extension.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  User _user = UserService().getUser();
  /* 
  User _user =  User(
      name: "Thomas Shelby ",
      phone: '9829326110',
      email: 'ad01santosh@gmail.com');
 */
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: _user))),
              child: CustomDOgTAg(
                user: _user ,
              ),
            ),
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SavedAddressScreenScreen())),
              child: Card(
                  color: Constant.cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saved Address'),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.home),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Home'),
                                    Text(
                                      'Set Home',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.work_outline_sharp),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Work'),
                                    Text('Set Home',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            customCard(
                child: customRow(
                    icon: Icon(Icons.attach_money),
                    title: 'Discount',
                    subtitle: 'Refer and get discounts')),
            customCard(
                child: customRow(
              icon: Icon(Icons.language),
              title: 'Language',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.security),
              title: 'Permission',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.money),
              title: 'Add Payment',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.help),
              title: 'Help',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.privacy_tip),
              title: 'Privacy Policy',
            )),
            customCard(
                child: InkWell(
              onTap: () {
                Provider.of<LoginManger>(context, listen: false)
                    .logout(() => print("error logout"));
              },
              child: customRow(
                icon: Icon(Icons.logout),
                title: 'Logout',
              ),
            ))
          ],
        ),
      ),
    );
  }

  customRow({Icon icon, String title, String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                // Text(subtitle ?? '')
              ],
            ),
          )
        ],
      ),
    );
  }

  customCard({Widget child}) {
    return Card(
        color: Constant.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: child);
  }
}

class CustomDOgTAg extends StatelessWidget {
  const CustomDOgTAg({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Constant.cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: user.image.isNullOrEmpty()
                    ? AssetImage('assets/avatar.png')
                    : NetworkImage(user.image),
                radius: 30,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name ??''),
                  Text(user.phone ??''),
                  Text(user.email ?? '')
                ],
              ),
            )
          ],
        ));
  }
}
