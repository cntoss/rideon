import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/route/navigateToRoute.dart';
import 'package:rideon/screens/widgets/circleIcon.dart';

import 'addressListScreen.dart';

class SavedAddressView extends StatelessWidget {
  final AddressType addressType;
  final LocationDetail source;
  SavedAddressView(this.addressType, {this.source});
  @override
  Widget build(BuildContext context) {
    Widget icon = CircularIcon(
        icon: addressType == AddressType.Work
            ? Icon(Icons.work_outline_sharp)
            : Icon(Icons.home));
    return ValueListenableBuilder(
        valueListenable: Hive.box(hiveBoxName).listenable(),
        builder: (context, _box, _) {
          List<SavedAddressModel> _list = List<SavedAddressModel>();
          List<dynamic> result = _box.get(
            hkAddressType,
            defaultValue: List<SavedAddressModel>(),
          );
          _list = result.cast();
          SavedAddressModel _workAddress =
              _list.where((e) => e.type == addressType).length != 0
                  ? _list.where((e) => e.type == addressType).first
                  : SavedAddressModel();

          if (_workAddress.locationName == null)
            return TextButton.icon(
                icon: icon,
                onPressed: () =>
                    NavigateToRoute().navigateToAdd(type: addressType),
                style: Constant.buttonStyle,
                label: Text(
                    addressType == AddressType.Work ? 'Set Home' : 'Set Home'));
          else
            return TextButton.icon(
                icon: icon,
                onPressed: () {
                  if (source != null) {
                    NavigateToRoute().navigateFromHome(
                        source: source,
                        type: addressType,
                        address: _workAddress);
                  } else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedAddressScreenScreen()));
                },
                style: Constant.buttonStyle,
                label: Flexible(
                  child: Text(
                    _workAddress.locationName ?? '',
                  ),
                ));
        });
  }
}
