import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/maps/web_service/distance.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:rideon/screens/widgets/loader.dart';

class ParcelScreen extends StatefulWidget {
  @override
  _ParcelScreenState createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  var _formKey = GlobalKey<FormState>();
  //cosysapps@cosys.com.np
  LocationDetail _toAddress = LocationDetail();
  LocationDetail _fromAddress = LocationDetail();

  TextEditingController _toController;
  TextEditingController _fromController;

  TextEditingController _body = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();

  TextStyle textTitle = TextStyle();
  bool _isLoading = false;
  bool _showConfirmation = false;
  DistanceResponse distanceResponse;
  @override
  void initState() {
    super.initState();
    _toController =
        TextEditingController(text: _toAddress.formattedAddress ?? '');
    _fromController =
        TextEditingController(text: _fromAddress.formattedAddress ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Card(
                elevation: 0,
                color: Constant.cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: !_showConfirmation
                        ? Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Pickup Location"),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlacePicker(
                                                        usePlaceDetailSearch:
                                                            true,
                                                        initialPosition:
                                                            SOURCE_LOCATION,
                                                        useCurrentLocation:
                                                            true,
                                                        onPlacePicked: (r) {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            _fromController
                                                                    .text =
                                                                r.formattedAddress;
                                                          });
                                                          _fromAddress =
                                                              LocationDetail
                                                                  .fromPickResult(
                                                                      r);
                                                        })));
                                      },
                                      child: TextFormField(
                                        enabled: false,
                                        maxLines: 3,
                                        minLines: 1,
                                        controller: _fromController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Pick loction must not be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          hintText: "Pickup Location",
                                          disabledBorder: Constant.inputBorder,
                                          labelStyle: Constant.whiteText,
                                          errorStyle: TextStyle(
                                            color: Theme.of(context)
                                                .errorColor, // or any other color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("Drop Location"),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlacePicker(
                                                        usePlaceDetailSearch:
                                                            true,
                                                        initialPosition:
                                                            SOURCE_LOCATION,
                                                        useCurrentLocation:
                                                            true,
                                                        onPlacePicked: (r) {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            _toController.text =
                                                                r.formattedAddress;
                                                          });
                                                          _toAddress =
                                                              LocationDetail
                                                                  .fromPickResult(
                                                                      r);
                                                        })));
                                      },
                                      child: TextFormField(
                                        enabled: false,
                                        maxLines: 3,
                                        minLines: 1,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        controller: _toController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Drop location must not be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          disabledBorder: Constant.inputBorder,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          hintText: "Dropof Location",
                                          labelStyle: Constant.whiteText,
                                          errorStyle: TextStyle(
                                            color: Theme.of(context)
                                                .errorColor, // or any other color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("Receiver Name"),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _name,
                                    onFieldSubmitted: (v) {
                                      // _bodyFocus.requestFocus();
                                    },
                                    style: TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      hintText: 'Name',
                                      enabledBorder: Constant.inputBorder,
                                      //focusedBorder: Constant.inputBorder,
                                      labelStyle: Constant.whiteText,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Name must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Text("Receiver Contact No", style: textTitle),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _phone,
                                    keyboardType: TextInputType.phone,
                                    onFieldSubmitted: (v) {
                                      //  _bodyFocus.requestFocus();
                                    },
                                    style: TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                        hintText: 'Contact No.',
                                        enabledBorder: Constant.inputBorder,
                                        //focusedBorder: Constant.inputBorder,
                                        errorStyle: TextStyle(fontSize: 15),
                                        labelStyle: Constant.whiteText),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Contact no must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Text('Notes', style: textTitle),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    maxLines: null,
                                    minLines: 3,
                                    // focusNode: _bodyFocus,
                                    keyboardType: TextInputType.multiline,
                                    controller: _body,
                                    style: TextStyle(fontSize: 15),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      labelText: 'Delivery details...',
                                      enabledBorder: Constant.inputBorder,
                                      // focusedBorder: Constant.inputBorder,
                                      errorStyle: TextStyle(fontSize: 15),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Note must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        color: Theme.of(context).primaryColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Continue',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 18,
                                              )),
                                        ),
                                        onPressed: _continueToDelivery),
                                  ),
                                )
                              ],
                            ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Text("Delivery Information"),
                                Text(
                                    "Estimated Distance ${distanceResponse.results.first.elements.first.distance}"),
                                Text("Estimated Price"),
                              ])),
              ),
            ),
          ),
          if (_isLoading) Loader()
        ],
      ),
    );
  }

  _continueToDelivery() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      distanceResponse = await GoogleDistanceMatrix(apiKey: googleAPIKey)
          .distanceWithLocation(
              [_fromAddress.geometry.location], [_toAddress.geometry.location]);
      if (distanceResponse != null) {
        setState(() {
          _showConfirmation = true;
        });
      }
    }
  }
}
