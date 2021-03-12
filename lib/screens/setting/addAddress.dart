import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/screens/widgets/animatedPin.dart';
import 'package:rideon/screens/widgets/customCard.dart';
import 'package:rideon/services/helper/savedAddressService.dart';

class AddAddress extends StatefulWidget {
  AddAddress({this.address, this.title, Key key}) : super(key: key);
  final SavedAddressModel address;
  final String title;
  @override
  _AddAddressState createState() => _AddAddressState(this.address);
}

class _AddAddressState extends State<AddAddress> {
  _AddAddressState(this.address);
  SavedAddressModel address;
  bool _isReadyToSave = false;
  TextEditingController _addressName;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _detail = TextEditingController();
  Icon icon = Icon(Icons.edit_outlined);
  @override
  void initState() {
    super.initState();
    address.type = address.type ?? AddressType.Other;
    _addressName = TextEditingController(text: address.locationName ?? '');
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Save Address'),
        actions: [
          TextButton.icon(
              onPressed: () {
                if (address.type == AddressType.Other) {
                  _formKey.currentState.save();
                  if (_formKey.currentState.validate()) {
                    address.detail = _detail.text;
                    SavedAddressService()
                        .saveAddress(savedAddressModel: address);
                    Navigator.pop(context);
                  }
                } else {
                  SavedAddressService().saveAddress(savedAddressModel: address);
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.done),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text('Save', style: Theme.of(context).textTheme.headline6),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: () {
                        Navigator.push(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.push_pin,
                                                  size: 36,
                                                  color: Colors.green),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              AnimatedPin(
                                                  child: Icon(Icons.push_pin,
                                                      size: 36,
                                                      color: Colors.green)),
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
                                selectedPlaceWidgetBuilder: (_, selectedPlace,
                                    state, isSearchBarFocused) {
                                  return isSearchBarFocused
                                      ? Container()
                                      // Use FloatingCard or just create your own Widget.
                                      : FloatingCard(
                                          bottomPosition:
                                              0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                          leftPosition: 10.0,
                                          rightPosition: 10.0,
                                          width: 500,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: state ==
                                                  SearchingState.Searching
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Column(
                                                  children: [
                                                    ElevatedButton(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              '${selectedPlace.name} ${selectedPlace.formattedAddress}'),
                                                        ),
                                                        onPressed: () {}),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Constant
                                                                      .cardColor)),
                                                      child: Container(
                                                        //padding: const EdgeInsets.all(8.0),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Center(
                                                            child:
                                                                Text('Select')),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          address = SavedAddressModel
                                                              .fromPickResult(
                                                                  selectedPlace);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                ),
                                        );
                                },
                              ),
                            ));
                      }),
                  Flexible(
                    child: Text(
                      address.locationName ?? '',
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text('Selected Address type'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.home,
                        color: address.type == AddressType.Home
                            ? Colors.black
                            : Colors.black38,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                            color: address.type == AddressType.Home
                                ? Colors.black
                                : Colors.black38),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.work_outline_sharp,
                          color: address.type == AddressType.Work
                              ? Colors.black
                              : Colors.black38),
                      Text('Office',
                          style: TextStyle(
                              color: address.type == AddressType.Work
                                  ? Colors.black
                                  : Colors.black38))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star,
                          color: address.type == AddressType.Other
                              ? Colors.black
                              : Colors.black38),
                      Text(
                        'Others',
                        style: TextStyle(
                            color: address.type == AddressType.Other
                                ? Colors.black
                                : Colors.black38),
                      )
                    ],
                  )
                ],
              ),
            ),
            if (address.type == AddressType.Other)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _detail,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Enter Full Name';
                      else
                        return null;
                    },
                    onChanged: (_) {
                      address.locationName = _addressName.text;
                      setState(() {
                        _isReadyToSave = true;
                      });
                    },
                    decoration: InputDecoration(
                        errorStyle: Constant.errorStyle,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)),
                        labelText: "Address Name",
                        labelStyle: Constant.whiteText),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
