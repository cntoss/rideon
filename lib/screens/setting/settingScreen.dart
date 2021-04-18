import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/screens/localAddress/savedAddressView.dart';
import 'package:rideon/screens/profile/profileScreen.dart';
import 'package:rideon/screens/localAddress/addressListScreen.dart';
import 'package:rideon/services/helper/userService.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:rideon/services/utils/extension.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  User _user = UserService().getUser();

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .65,
      padding: EdgeInsets.all(8),
      child: ListView(
        children: [
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: _user))),
            child: CustomDOgTAg(
              user: _user,
            ),
          ),
          Card(
              color: Constant.cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Saved Address'),
                  ),
                  SavedAddressView(AddressType.Home),
                  SavedAddressView(AddressType.Work),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedAddressScreenScreen())),
                    child: Text(
                      'More Saved Address',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              )),
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
            title: 'Add Money',
          )),

          customCard(
              child: customRow(
            icon: Icon(Icons.badge),
            title: 'Rewards',
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
            Flexible(child: Text(user.name ?? '')),
          ],
        ));
  }
}
