import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/savedAddressModel.dart';
import 'package:rideon/screens/setting/addAddress.dart';
import 'package:rideon/screens/setting/editSavedAddress.dart';
import 'package:rideon/screens/widgets/circleIcon.dart';

enum AddressType { home, work, other }

class SavedAddressScreenScreen extends StatefulWidget {
  @override
  _SavedAddressScreenState createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreenScreen> {
  var _jsonString = [
    {
      "id": 1,
      "type": "Home",
      "location": null,
      "locationName": "Pulchowk , Lalitpur"
    },
    {
      "id": 2,
      "type": "Office",
      "location": null,
      "locationName": "Thapathali , Kathmandu"
    },
    {
      "id": 3,
      "type": "Others",
      "location": null,
      "locationName": null
    }
  ];

  List<SavedAddressModel> _saveAddress = List();
  
  @override
  void initState() {
    super.initState();
    for (var x in _jsonString) _saveAddress.add(SavedAddressModel.fromJson(x));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Address')),
      body: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: 3,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1),
        itemBuilder: (BuildContext context, int x) {
          return ListTile(
            leading: Column(
              children: [
                if (_saveAddress[x].type == "Home")
                  CircularIcon(icon: Icon(Icons.home)),
                if (_saveAddress[x].type == "Office")
                  CircularIcon(icon: Icon(Icons.work_outline_sharp)),
                if (_saveAddress[x].type != "Office" &&
                    _saveAddress[x].type != "Home")
                  CircularIcon(icon: Icon(Icons.star)),
              ],
            ),
            title: Text(
              _saveAddress[x].type,
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
                          builder: (context) =>
                              EditavedAddress(address:_saveAddress[x]),
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
                  builder: (context) => AddAddress(
                        savedAddressModel: SavedAddressModel(
                            id: null,
                            type: '',
                            location: null,
                            locationName: ''),
                        title: 'Add Location',
                      )))),
    );
  }
}
