import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/maps/src/utils/uuid.dart';
import 'package:rideon/models/savedAddress/addressType.dart';
import 'package:rideon/models/savedAddress/savedAddressModel.dart';
import 'package:rideon/screens/widgets/animatedPin.dart';
import 'package:rideon/screens/widgets/customCard.dart';
import 'package:rideon/services/helper/savedAddressService.dart';

class AddAddress extends StatefulWidget {
  AddAddress({this.address, this.title});
  final SavedAddressModel address;
  final String title;
  @override
  _AddAddressState createState() => _AddAddressState(this.address);
}

class _AddAddressState extends State<AddAddress> {
  _AddAddressState(this.address);
  SavedAddressModel address;
  TextEditingController _addressName;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _detail;
  @override
  void initState() {
    super.initState();
    address.type = address.type ?? AddressType.Other;
    _addressName = TextEditingController(text: address.locationName ?? '');
    _detail = TextEditingController(text: address.detail ?? '');
  }

  _addAddress() {
    if (address.id != null)
      SavedAddressService().editAddress(savedAddressModel: address);
    else {
      address.id = Uuid().generateV4();
      SavedAddressService().saveAddress(savedAddressModel: address);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Save Address'),
        actions: [
          TextButton.icon(
              onPressed: () {
                if (address.type == AddressType.Other) {
                  //to check _details is null or not
                  _formKey.currentState.save();
                  if (_formKey.currentState.validate()) {
                    address.detail = _detail.text;
                    _addAddress();
                  }
                } else
                  _addAddress();
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
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Constant.cardColor,
                    borderRadius: BorderRadius.circular(10)),
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
                                  onPlacePicked: (result) {
                                    setState(() {
                                      SavedAddressModel newAddress =
                                          SavedAddressModel.fromPickResult(
                                              result);
                                      newAddress.detail = address.detail;
                                      newAddress.type = address.type;
                                      newAddress.id = address.id;
                                      address = newAddress;
                                    });
                                    Navigator.pop(context);
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
