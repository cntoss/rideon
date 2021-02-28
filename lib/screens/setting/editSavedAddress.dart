import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/savedAddressModel.dart';
import 'package:rideon/screens/widgets/customCard.dart';

class EditavedAddress extends StatefulWidget {
  EditavedAddress({this.address, Key key}) : super(key: key);
  final SavedAddressModel address;
  @override
  _EditavedAddressState createState() => _EditavedAddressState(this.address);
}

class _EditavedAddressState extends State<EditavedAddress> {
  _EditavedAddressState(this.address);
  SavedAddressModel address;
  bool _isReadyToSave = false;
  TextEditingController _addressName = TextEditingController(text: '');
  Icon icon = Icon(Icons.edit_outlined);

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Save Address"),
      actions: [
         TextButton.icon(
              onPressed: () {
                if (_isReadyToSave) {
                  //todo:saved
                 // UserService().addUser(user: _user);
                
                setState(() {
                  _isReadyToSave = !_isReadyToSave;
                  icon = _isReadyToSave
                      ? Icon(Icons.edit_off)
                      : Icon(Icons.edit_outlined);
                });
                }
              },
              icon: icon,
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Save' ,
                    style: Theme.of(context).textTheme.headline6),
              ))
      ],),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
                child: Container(
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(address.locationName ??
                    ' Pulchowk Jawdal 117 , Lalitput, Nepal'),
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
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
                        color: address.type == "Home"
                            ? Colors.black
                            : Colors.black38,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                            color: address.type == "Home"
                                ? Colors.black
                                : Colors.black38),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.work_outline_sharp,
                          color: address.type == "Office"
                              ? Colors.black
                              : Colors.black38),
                      Text('Office',
                          style: TextStyle(
                              color: address.type == "Office"
                                  ? Colors.black
                                  : Colors.black38))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star,
                          color: address.type == "Others"
                              ? Colors.black
                              : Colors.black38),
                      Text(
                        'Others',
                        style: TextStyle(
                            color: address.type == "Others"
                                ? Colors.black
                                : Colors.black38),
                      )
                    ],
                  )
                ],
              ),
            ),
            if (address.type == "Others")
              CustomCard(
                  child: Container(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _addressName,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Enter Full Name';
                      else if (value.length < 5 && !value.contains(' '))
                        return "Enter Valid Name";
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
                        prefixIcon: Icon(
                          Icons.person_rounded,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                        errorStyle: Constant.errorStyle,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "Address Name",
                        labelStyle: Constant.whiteText),
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }
}
