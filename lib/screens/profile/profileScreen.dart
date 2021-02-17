import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/screens/profile/chnagePasswordScreen.dart';
import 'package:rideon/screens/widgets/customCard.dart';
import 'package:rideon/services/helper/userService.dart';
import 'package:rideon/services/utils/extension.dart';

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
  TextEditingController _phoneNumberCOntroller, _nameCotroler, _emailController;
  Icon icon = Icon(Icons.edit_outlined);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumberCOntroller = TextEditingController(text: _user.phone);
    _emailController = TextEditingController(text: _user.email ?? '');
    _nameCotroler = TextEditingController(text: _user.name);
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          errorStyle: Constant.errorStyle,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Colors.green)),
                          labelText: "Full Name",
                          labelStyle: Constant.whiteText),
                    ),
                  ),
                  OpenContainer(
                    closedElevation: 0,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedColor: Constant.cardColor,
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _phoneNumberCOntroller,
                            enabled: false,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: (s) {
                              if (s.trim().length < 10)
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                                counterText: "",
                                labelText: "Phone Number",
                                labelStyle: Constant.whiteText),
                          ),
                        ),
                      );
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _phoneNumberCOntroller,
                              enabled: false,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  counterText: "",
                                  labelText: "Phone Number",
                                  labelStyle: Constant.whiteText),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _emailController,
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          errorStyle: Constant.errorStyle,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Colors.green)),
                          labelText: "Email",
                          hintText: "Enter valid email",
                          labelStyle: Constant.whiteText),
                    ),
                  ),
                  OpenContainer(
                    closedElevation: 0,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedColor: Constant.cardColor,
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return Center(child: ChnagePasswordScreen());
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
            ))
          ],
        ),
      ),
    );
  }
}
