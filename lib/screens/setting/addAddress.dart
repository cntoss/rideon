import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/savedAddressModel.dart';
import 'package:rideon/screens/setting/addSavedAddress.dart';
import 'package:rideon/screens/widgets/customCard.dart';

class AddAddress extends StatefulWidget {
  final SavedAddressModel savedAddressModel;
  final String title;
  AddAddress({this.savedAddressModel, this.title, Key key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState(this.savedAddressModel);
}

class _AddAddressState extends State<AddAddress> {
  _AddAddressState(this._address);
  SavedAddressModel _address;

  TextEditingController _typeController;
  TextEditingController _locationNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _typeController =
        TextEditingController(text: widget.savedAddressModel.locationName);
    _locationNameController =
        TextEditingController(text: widget.savedAddressModel.locationName);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: CustomCard(
                  child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pop(context)),
                      IconButton(
                          icon: Icon(Icons.map_outlined),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddSavedAddress(
                                        savedAddressModel: _address,
                                        title: "Chose on map",
                                      ))))
                    ]),
                Container(
                  height: 50,
                  width: width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Type Address"),
                  ),
                )
              ])),
            )
          ],
        ),
      ),
    );
  }
}
