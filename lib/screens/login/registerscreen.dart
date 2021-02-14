import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/screens/home/homePageWarper.dart';
import 'package:rideon/screens/widgets/appButton.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:intl/intl.dart';

enum Gender { male, female, other }

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController _phoneNumberCOntroller;
  TextEditingController _passwordCOntroller, _nameCotroler, _econtact;
  String gender;
  bool _isAccepted;
  final _formKey = GlobalKey<FormState>();
  FocusNode _pwFocus;
  DateTime _selectedDate;
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumberCOntroller = TextEditingController(text: "");
    _passwordCOntroller = TextEditingController(text: "");
    _pwFocus = FocusNode();
  }

  Gender _gender = Gender.male;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneNumberCOntroller.dispose();
    _passwordCOntroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _manager = Provider.of<LoginManger>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Register on  Ride on')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameCotroler,
                onFieldSubmitted: (v) {
                  _pwFocus.requestFocus();
                },
                validator: (value) {
                  if (value.isEmpty)
                    return 'Enter Full Name';
                  else if (value.length < 5 && !value.contains(' '))
                    return "Enter Valid Name";
                  else
                    return null;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: Colors.grey,
                    ),
                    
                      border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                   errorStyle: TextStyle(color:Constant.textColor),
                  /*   errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)), */
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.green)),
                    labelText: "Full Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _phoneNumberCOntroller,
                focusNode: _pwFocus,
                onFieldSubmitted: (v) {
                  _pwFocus.requestFocus();
                },
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (s) {
                  if (s.trim().length < 6)
                    return Constant.phoneValidationError;
                  else
                    return null;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                   errorStyle: TextStyle(color:Constant.textColor),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    counterText: "",
                    labelText: "Phone Number"),
              ),
            ),
            //date
            Container(
              color: Colors.white70,
              margin: EdgeInsets.only(top: 15),
              child: TextFormField(
                focusNode: AlwaysDisabledFocusNode(),
                onTap: () {
                  _selectDate(context);
                },
                controller: _dateController,
                onFieldSubmitted: (v) {
                  _pwFocus.requestFocus();
                },
                validator: (s) {
                  if (s.isEmpty)
                    return 'Please select date of birth';
                  else
                    return null;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.grey,
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                    labelText: "Date of Birth"),
              ),
            ),

            Container(
              color: Colors.white70,
              margin: EdgeInsets.only(top: 15),
              child: TextFormField(
                controller: _econtact,
                onFieldSubmitted: (v) {
                  _pwFocus.requestFocus();
                },
                keyboardType: TextInputType.phone,
                validator: (s) {
                  if (s.trim().length < 6)
                    return 'Phone number must have exactly 10 digits';
                  else
                    return null;
                },
                maxLength: 10,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.contact_phone,
                      color: Colors.grey,
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                    counterText: "",
                    labelText: "Emergency Contact"),
              ),
            ),

            //gender
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: 20,
                child: Text(
                  "Select Gender",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (x) {
                      setState(() {
                        _gender = x;
                      });
                    }),
                new Text(
                  'Male',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (x) {
                      setState(() {
                        _gender = x;
                      });
                    }),
                new Text(
                  'Female',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                new Radio(
                  value: Gender.other,
                  groupValue: _gender,
                  onChanged: (x) {
                    setState(() {
                      _gender = x;
                    });
                  },
                ),
                new Text(
                  'Others',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),

            ValueListenableBuilder<LoginStates>(
              valueListenable: _manager.currentState,
              builder: (con, val, _) {
                if (val == LoginStates.error)
                  showLoginFailMessage(context, _manager);
                return AnimatedSwitcher(
                  child: val == LoginStates.loading
                      ? SizedBox(
                          key: ValueKey("1"),
                          height: 50,
                          child: Center(child: CircularProgressIndicator()))
                      : SizedBox(
                          /* width:
                                    MediaQuery.of(context).size.width * .554,*/
                          key: ValueKey("2"),
                          //height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //todo:navigation to login
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Already account? ',
                                        ),
                                        TextSpan(
                                            text: 'login',
                                            style:
                                                TextStyle(color: Colors.blue))
                                      ]),
                                ),
                                AppButton().appButton(
                                  small: true,
                                  text: "Continue",
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      _manager.login();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomePageWrapper(),
                                          ));
                                    }
                                  },
                                ),
                              ],
                            ),
                          )),
                  duration: Duration(milliseconds: 400),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLoginFailMessage(context, manager) {
    Future.delayed(Duration(seconds: 1), () {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(manager.errorText ?? Constant.defaultloginError)));
    });
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dateController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
