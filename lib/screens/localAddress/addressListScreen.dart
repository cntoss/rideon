import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/screens/localAddress/addAddress.dart';
import 'package:rideon/widgets/circleIcon.dart';
import 'package:rideon/services/helper/savedAddressService.dart';

class SavedAddressScreenScreen extends StatefulWidget {
  @override
  _SavedAddressScreenState createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreenScreen> {
  List<SavedAddressModel> _saveAddress =
      SavedAddressService().getSavedAddress();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Address')),
      body: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: _saveAddress.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1),
        itemBuilder: (BuildContext context, int x) {
          return ListTile(
            leading: Column(
              children: [
                if (_saveAddress[x].type == AddressType.Home)
                  CircularIcon(icon: Icon(Icons.home)),
                if (_saveAddress[x].type == AddressType.Work)
                  CircularIcon(icon: Icon(Icons.work_outline_sharp)),
                if (_saveAddress[x].type == AddressType.Other)
                  CircularIcon(icon: Icon(Icons.star)),
              ],
            ),
            title: (_saveAddress[x].detail ?? '') != ''
                ? Text(
                    _saveAddress[x].detail,
                    style: TextStyle(fontSize: 18),
                  )
                : Container(),
            subtitle: Text(
              _saveAddress[x].locationName ??
                  'Set ${_saveAddress[x].type} location',
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text("Edit"),
                    value: 'edit',
                  ),
                  PopupMenuItem(
                    child: Text("Delete"),
                    value: 'delete',
                  )
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case "edit":
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                              useCurrentLocation: true,
                              initialPosition: LatLng(
                                  _saveAddress[x].location.lat,
                                  _saveAddress[x].location.lng),
                              //initialSearchString: _saveAddress[x].locationName,
                              forceAndroidLocationManager: false,
                              onPlacePicked: (result) {
                                SavedAddressModel address =
                                    SavedAddressModel.fromPickResult(result);
                                address.detail = _saveAddress[x].detail;
                                address.type = _saveAddress[x].type;
                                address.id = _saveAddress[x].id;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddAddress(
                                      address: address,
                                      title: 'Edit Address',
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                              }),
                        ),
                      );
                    }
                    break;
                  case "delete":
                    {
                      SavedAddressService()
                          .deleteAddress(savedAddressModel: _saveAddress[x]);
                      setState(() {});
                    }
                    break;
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlacePicker(
              useCurrentLocation: true,
              onPlacePicked: (result) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddress(
                    address: SavedAddressModel.fromPickResult(result),
                    title: 'Add Location',
                  ),
                ),
              ).then((value) => setState(() {})),
            ),
          ),
        ),
      ),
    );
  }
}
