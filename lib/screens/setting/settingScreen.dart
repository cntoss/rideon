import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/route/navigateToRoute.dart';
import 'package:rideon/screens/profile/profileScreen.dart';
import 'package:rideon/screens/setting/addressListScreen.dart';
import 'package:rideon/screens/widgets/circleIcon.dart';
import 'package:rideon/services/helper/savedAddressService.dart';
import 'package:rideon/services/helper/userService.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:rideon/services/utils/extension.dart';

import 'addAddress.dart';

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
  SavedAddressModel _homeAddress =
      SavedAddressService().getSingleAddress(AddressType.Home);
  SavedAddressModel _workAddress =
      SavedAddressService().getSingleAddress(AddressType.Work);

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
                    TextButton.icon(
                        icon: CircularIcon(icon: Icon(Icons.home)),
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                    useCurrentLocation: true,
                                    onPlacePicked: (result) {
                                      SavedAddressModel address =
                                          SavedAddressModel.fromPickResult(
                                              result);
                                      address.type = AddressType.Home;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddAddress(
                                            address: address,
                                            title: 'Set Home Location',
                                          ),
                                        ),
                                      ).then((value) => setState(() {}));
                                    }),
                              ),
                            ),
                        style: Constant.buttonStyle,
                        label: Flexible(
                          child: Text(
                            _homeAddress.locationName ?? 'Set Home',
                          ),
                        )),
                    TextButton.icon(
                        icon: Icon(Icons.work_outline_sharp),
                        onPressed: () => NavigateToRoute()
                            .navigateToAdd(type: AddressType.Work)
                            .then((value) => setState(() {
                                  _workAddress = SavedAddressService()
                                      .getSingleAddress(AddressType.Work);
                                      print('fucked');
                                })),
                        style: Constant.buttonStyle,
                        label: Flexible(
                          child: Text(
                            _workAddress.locationName ?? 'Set Office',
                          ),
                        )),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SavedAddressScreenScreen())),
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
                  Text(user.name ?? ''),
                  Text(user.phone ?? ''),
                  Text(user.email ?? '')
                ],
              ),
            )
          ],
        ));
  }
}
