import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/savedAddressModel.dart';

class AddSavedAddress extends StatefulWidget {
  final SavedAddressModel savedAddressModel;
  final String title;
  AddSavedAddress({this.savedAddressModel, this.title, Key key})
      : super(key: key);

  @override
  _AddSavedAddressState createState() => _AddSavedAddressState();
}

class _AddSavedAddressState extends State<AddSavedAddress> {
  /* TextEditingController _typeController;
  TextEditingController _locationNameController;

  @override
  void initState() {
    super.initState();
    _typeController =
        TextEditingController(text: widget.savedAddressModel.locationName);
    _locationNameController =
        TextEditingController(text: widget.savedAddressModel.locationName);
  } */

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
        title: Text(widget.title)),
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
              child: Container(
                height: 30,
                color: Colors.white,
              ),
            ),
            Positioned(
                top: height / 1.25,
                width: width,
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: MaterialButton(
                    onPressed: () => print('okay'),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Confirm', style: Constant.whiteText ,),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
