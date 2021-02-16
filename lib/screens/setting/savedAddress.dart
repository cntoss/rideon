import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/savedAddressModel.dart';
import 'package:rideon/screens/setting/addSavedAddress.dart';

class SavedAddressScreenScreen extends StatefulWidget {
  @override
  _SavedAddressScreenState createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreenScreen> {
  var _jsonString = [
    {"type": "Home", "location": null, "locationName": "Pulchowk , Lalitpur"},
    {
      "type": "Office",
      "location": null,
      "locationName": "Thapathali , Kathmandu"
    },
    {"type": "May Favourite Resturents", "location": null, "locationName": null}
  ];

  List<SavedAddressModel> _saveAddress = List();
  @override
  void initState() {
    // TODO: implement initState
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddSavedAddress(
                        savedAddressModel: SavedAddressModel(
                            type: '', location: null, locationName: ''),
                        title: 'Add Location',
                      )))),
    );
  }
}

class CircularIcon extends StatelessWidget {
  final Icon icon;
  const CircularIcon({
    this.icon,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: icon,
        ),
        shape: CircleBorder(),
        color: Colors.grey,
        elevation: 1,
      ),
    );
  }
}
