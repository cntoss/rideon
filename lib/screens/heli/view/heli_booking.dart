import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/maps/google_maps_place_picker.dart';
import 'package:rideon/maps/web_service/directions.dart';
import 'package:rideon/models/googleModel/GeocodingModel.dart';
import 'package:rideon/models/heli/booking_mobel.dart';
import 'package:rideon/screens/heli/view/booking_details.dart';
import 'package:rideon/services/utils/extension.dart';

class HelicopterBookingPage extends StatefulWidget {
  HelicopterBookingPage({Key? key}) : super(key: key);

  @override
  _HelicopterBookingPageState createState() => _HelicopterBookingPageState();
}

class _HelicopterBookingPageState extends State<HelicopterBookingPage> {
  var _charterFormKey = GlobalKey<FormState>();
  var _tourFormKey = GlobalKey<FormState>();

  //cosysapps@cosys.com.np
  LocationDetail _toAddress = LocationDetail();
  LocationDetail _fromAddress = LocationDetail();
  LatLng _tia_coordinate = LatLng(27.6980899, 85.3570344);

  late TextEditingController _toController;
  late TextEditingController _fromController;

 late TextEditingController _note,
      _name,
      _phone,
      _emailController,
      _noOfAdult,
      _noOfChild;

  TextStyle textTitle = TextStyle();

  List<String> _tourPlan = [
    'Annapurna Tour',
    'Damodar Kunda',
    'Gosaikunda Helicopter'
  ];

  String? _selectedTour;
  @override
  void initState() {
    super.initState();
    _fromController =
        TextEditingController(text: 'Tribhuvan International Airport');
    _toController = TextEditingController(text: '');
    _name = TextEditingController(text: '');
    _note = TextEditingController(text: '');
    _phone = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _noOfAdult = TextEditingController(text: '');
    _noOfChild = TextEditingController(text: '');

    _fromAddress = LocationDetail(
        formattedAddress: 'Tribhuvan International Airport',
        geometry:
            Geometry(location:  Location(lat:27.6980899, lng:85.35922309999999)),
        placeId: "ChIJxSs0ayYa6zkRG6-JmoL6u3M");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Heli Charter",
              ),
              Tab(
                text: 'Heli Tour',
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          _tabBarBody(HeliType.Charter, _charterFormKey),
          _tabBarBody(HeliType.Tour, _tourFormKey)
        ]),
      ),
    );
  }

  Widget _tabBarBody(HeliType _heliType, GlobalKey<FormState> _formKey) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Card(
          elevation: 0,
          color: cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Starting place"),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                      usePlaceDetailSearch: true,
                                      initialPosition: _tia_coordinate,
                                      useCurrentLocation: false,
                                      onPlacePicked: (r) {
                                        Navigator.pop(context);
                                        setState(() {
                                          _fromController.text =
                                              r.formattedAddress!;
                                        });
                                        _fromAddress =
                                            LocationDetail.fromPickResult(r);
                                      })));
                        },
                        child: TextFormField(
                          enabled: false,
                          maxLines: 3,
                          minLines: 1,
                          controller: _fromController,
                          validator: (value) {
                            if (value == null) {
                              return 'Starting place must not be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Starting Place",
                            errorStyle: TextStyle(
                              color: Theme.of(context)
                                  .errorColor, // or any other color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text("Ending place"),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                      usePlaceDetailSearch: true,
                                      useCurrentLocation: true,
                                      //v2
                                      initialPosition: SOURCE_LOCATION,
                                      onPlacePicked: (r) {
                                        Navigator.pop(context);
                                        setState(() {
                                          _toController.text =
                                              r.formattedAddress!;
                                        });
                                        _toAddress =
                                            LocationDetail.fromPickResult(r);
                                      })));
                        },
                        child: TextFormField(
                          enabled: false,
                          maxLines: 3,
                          minLines: 1,
                          keyboardType: TextInputType.streetAddress,
                          controller: _toController,
                          validator: (value) {
                            if (value == null ) {
                              return 'End place must not be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Ending Location",
                            errorStyle: TextStyle(
                              color: Theme.of(context)
                                  .errorColor, // or any other color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text("Name"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _name,
                      onFieldSubmitted: (v) {
                        // _noteFocus.requestFocus();
                      },
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        //focusedBorder: Constant.inputBorder,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Name must not be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Text("Contact Number", style: textTitle),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (v) {
                        //  _noteFocus.requestFocus();
                      },
                      style: TextStyle(fontSize: 15),
                      maxLength: 10,
                      decoration: InputDecoration(
                          hintText: 'Contact No.', counterText: ''),
                      validator: (value) {
                        if (value == null ) {
                          return 'Contact no must not be empty';
                        } else if (value.length < 7) {
                          return 'Enter valid contact no.';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  //email
                  Text("Email", style: textTitle),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (s) {
                        if(s == null) return null;
                        return s.isValidEmail()
                            ? null
                            : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid email address.";
                      },
                      //onSaved: (_) => _user.email = _emailController.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline_outlined,
                          color: Colors.grey,
                        ),
                        labelText: "Email",
                        hintText: "Enter valid email",
                      ),
                    ),
                  ),
                  if (_heliType == HeliType.Charter)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("No of Adults", style: textTitle),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: _noOfAdult,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (v) {
                                  // _noteFocus.requestFocus();
                                },
                                style: TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'No of adults',
                                  //focusedBorder: Constant.inputBorder,
                                ),
                                /*  validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Passenger number must not be empty';
                                      } else {
                                        return null;
                                      }
                                    }, */
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("No of Child", style: textTitle),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: _noOfChild,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (v) {
                                  // _noteFocus.requestFocus();
                                },
                                style: TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'No of child',
                                  //focusedBorder: Constant.inputBorder,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  if (_heliType == HeliType.Tour)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Tour Plan', style: textTitle),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: DropdownButton<String>(
                              value: _selectedTour,
                              hint: Text(
                                'Select Tour Plan',
                                style: textTitle,
                              ),
                              disabledHint: Text(
                                'Select tour plan',
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color:
                                    Theme.of(context).textTheme.bodyText2!.color,
                              ),
                              isExpanded: true,
                              // isDense: true,
                              underline: Container(),
                              items: _tourPlan.map((String tourPlan) {
                                return DropdownMenuItem<String>(
                                  value: tourPlan,
                                  child: Text(tourPlan,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .color,
                                          fontSize: 15)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if(newValue != null)
                                setState(() {
                                  _selectedTour = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                  Text('Details', style: textTitle),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      maxLines: null,
                      minLines: 3,
                      // focusNode: _noteFocus,
                      keyboardType: TextInputType.multiline,
                      controller: _note,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        counterText: "",
                        labelText: 'Charter Details',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        child: Padding(
                          padding: bottonPadding,
                          child: Text('Continue', style: bottonStyle),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // _formKey.currentState.save();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailsPage(
                                  HelicopterBookingModel(
                                    fromAddress: _fromAddress,
                                    toAddress: _toAddress,
                                    name: _name.text,
                                    phone: _phone.text,
                                    email: _emailController.text,
                                    details: _note.text,
                                    noOfAdults: _noOfAdult.text,
                                    noOfChild: _noOfChild.text,
                                    tourPlane: _selectedTour,
                                    type: _heliType,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* class _NoOfPassenger extends StatefulWidget {
 final String type;
final TextEditingController controller;
  final FocusNode node;
  const _NoOfPassenger({Key key, this.type, this.controller, this.node }) : super(key: key);

  @override
  _NoOfPassengerState createState() => _NoOfPassengerState();
}

class _NoOfPassengerState extends State<_NoOfPassenger> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
} */
