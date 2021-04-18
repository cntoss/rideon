import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/screens/profile/add_single_field.dart';
import 'package:rideon/screens/profile/changePasswordScreen.dart';
import 'package:rideon/screens/widgets/customCard.dart';
import 'package:rideon/services/helper/userService.dart';
import 'package:rideon/services/utils/extension.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({this.user, Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState(this.user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState(this._user);
  User _user;
  bool _enable = false;
  TextEditingController _phoneNumberCOntroller,
      _econtact,
      _nameCotroler,
      _emailController;
  Icon icon = Icon(Icons.edit_outlined);
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate;
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneNumberCOntroller = TextEditingController(text: _user.phone);
    _emailController = TextEditingController(text: _user.email ?? '');
    _nameCotroler = TextEditingController(text: _user.name);
    _econtact = TextEditingController(text: "");
    _dateController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton.icon(
              onPressed: () {
                if (_enable) {}
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  UserService().addUser(user: _user);
                }
                setState(() {
                  _enable = !_enable;
                  icon = _enable
                      ? Icon(Icons.edit_rounded)
                      : Icon(Icons.edit_outlined);
                });
              },
              icon: icon,
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_enable ? 'Save' : 'Edit',
                    style: Theme.of(context).textTheme.headline6),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            CustomCard(
              child: Stack(children: [
                CircleAvatar(
                  backgroundImage: _user.image.isNullOrEmpty()
                      ? AssetImage('assets/avatar.png')
                      : NetworkImage(_user.image),
                  radius: 50,
                ),
                /*  child: _user.image.isNullOrEmpty()
                      ? Image.asset('assets/avatar.png')
                      : NetworkImage(_user.image) */

                if (_enable)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.camera_alt_outlined),
                  )
              ]),
            ),
            CustomCard(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameCotroler,
                    enabled: _enable,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Enter Full Name';
                      else if (value.length < 5 && !value.contains(' '))
                        return "Enter Valid Name";
                      else
                        return null;
                    },
                    onSaved: (_) => _user.name = _nameCotroler.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Colors.grey,
                      ),
                      labelText: "Full Name",
                    ),
                  ),
                  OpenContainer(
                    closedElevation: 0,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedColor: Constant.cardColor,
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return Center(child: AddSingleField());
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          controller: _phoneNumberCOntroller,
                          enabled: _enable,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(height: 0.5),
                            prefixIcon: Icon(
                              Icons.phone_iphone_rounded,
                              color: Colors.grey,
                            ),
                            labelText: "Phone Number",
                          ),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _econtact,
                      /* onFieldSubmitted: (v) {
                        _pwFocus.requestFocus();
                      }, */
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
                          counterText: "",
                          labelText: "Emergency Contact"),
                    ),
                  ),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: _enable,
                    validator: (s) {
                      return s.isValidEmail()
                          ? null
                          : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid email address.";
                    },
                    onSaved: (_) => _user.email = _emailController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail_outline_outlined,
                        color: Colors.grey,
                      ),
                      labelText: "Email",
                      hintText: "Enter valid email",
                    ),
                  ),

                  //date
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      focusNode: AlwaysDisabledFocusNode(),
                      onTap: () {
                        _selectDate(context);
                      },
                      controller: _dateController,
                      /* onFieldSubmitted: (v) {
                        _pwFocus.requestFocus();
                      },
                       */
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
                          labelText: "Date of Birth"),
                    ),
                  ),

                  OpenContainer(
                    closedElevation: 0,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedColor: Constant.cardColor,
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return Center(child: ChangePasswordScreen());
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Change password?",
                            style: TextStyle(
                                color: Constant.textColor, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
            )
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1910),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                //primary: Colors.tealAccent,
                onPrimary: Colors.white,
                surface: Colors.redAccent,
                onSurface: Colors.black45,
              ),
              textTheme: TextTheme(bodyText2: TextStyle(color: Colors.blue)),
              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
