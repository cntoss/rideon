import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/screens/setting/addAddress.dart';
import 'package:rideon/screens/widgets/animatedPin.dart';
import 'package:rideon/screens/widgets/circleIcon.dart';
import 'package:rideon/services/helper/savedAddressService.dart';

class SavedAddressScreenScreen extends StatefulWidget {
  @override
  _SavedAddressScreenState createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreenScreen> {
  List<SavedAddressModel> _saveAddress = SavedAddressService/*  */().getSavedAddress();

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
              title: Text(
                _saveAddress[x].detail??'',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                _saveAddress[x].locationName ??
                    'Set ${_saveAddress[x].type} location',
                style: TextStyle(fontSize: 14, color: Constant.textColor),
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
                            builder: (context) => AddAddress(
                              address: _saveAddress[x],
                              title: 'Edit Address',
                            ),
                          ),
                        );
                      }
                      break;
                    case "user":
                      {
                        print('delete');
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
                    pinBuilder: (context, state) {
                      if (state == PinState.Idle) {
                        return Stack(
                          children: <Widget>[
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.push_pin,
                                      size: 36, color: Colors.green),
                                  SizedBox(height: 42),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Stack(
                          children: <Widget>[
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AnimatedPin(
                                      child: Icon(Icons.push_pin,
                                          size: 36, color: Colors.green)),
                                  SizedBox(height: 42),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                    selectedPlaceWidgetBuilder:
                        (_, selectedPlace, state, isSearchBarFocused) {
                      return isSearchBarFocused
                          ? Container()
                          // Use FloatingCard or just create your own Widget.
                          : FloatingCard(
                              bottomPosition:
                                  0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                              leftPosition: 10.0,
                              rightPosition: 10.0,
                              width: 500,
                              borderRadius: BorderRadius.circular(12.0),
                              child: state == SearchingState.Searching
                                  ? Center(child: CircularProgressIndicator())
                                  : Column(
                                      children: [
                                        ElevatedButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  '${selectedPlace.name} ${selectedPlace.formattedAddress}'),
                                            ),
                                            onPressed: () {}),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Constant.cardColor)),
                                            child: Container(
                                              //padding: const EdgeInsets.all(8.0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child:
                                                  Center(child: Text('Select')),
                                            ),
                                            onPressed: () =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddAddress(
                                                              address: SavedAddressModel
                                                                  .fromPickResult(
                                                                      selectedPlace),
                                                              title:
                                                                  'Add Location',
                                                            ))).then((value) => setState((){})))
                                      ],
                                    ),
                            );
                    },
                  ),
                ))));
  }
}
