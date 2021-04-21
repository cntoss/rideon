import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/user/userModel.dart';
import 'package:rideon/screens/login/loginPage.dart';
import 'package:rideon/widgets/appButton.dart';
import 'package:rideon/widgets/customCard.dart';
import 'package:rideon/services/login/loginManager.dart';

enum Gender { male, female, other }

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController _phoneNumberCOntroller;
  TextEditingController _passwordCOntroller, _nameCotroler, _emailController;
  String gender;
  final _formKey = GlobalKey<FormState>();
  FocusNode _phoneFocus;
  FocusNode _emailFocus;

  @override
  void initState() {
    super.initState();
    _nameCotroler = TextEditingController(text: "");
    _phoneNumberCOntroller = TextEditingController(text: "");
    _passwordCOntroller = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _phoneFocus = FocusNode();
    _emailFocus = FocusNode();
  }

  Gender _gender = Gender.male;

  @override
  void dispose() {
    super.dispose();
    _phoneNumberCOntroller.dispose();
    _passwordCOntroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _manager = Provider.of<LoginManger>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Register on  Ride on')),
        body: Container(
          padding: EdgeInsets.all(8),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _nameCotroler,
                          onFieldSubmitted: (v) {
                            _phoneFocus.requestFocus();
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
                              labelText: "Full Name"),
                        ),
                      ),
                      //phone
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _phoneNumberCOntroller,
                          focusNode: _phoneFocus,
                          onFieldSubmitted: (v) {
                            _emailFocus.requestFocus();
                          },
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (s) {
                            if (s.trim().length < 6)
                              return phoneValidationError;
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Colors.grey,
                              ),
                              counterText: "",
                              labelText: "Phone Number"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          validator: (value) {
                            if (value.isNotEmpty) {
                              if (value.length < 5)
                                return "Enter Valid Name";
                              else
                                return null;
                            } else
                              return null;
                          },
                          keyboardType: TextInputType.emailAddress,
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

                      //gender
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            "Select Gender",
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                              value: Gender.male,
                              groupValue: _gender,
                              activeColor: Colors.black,
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
                              activeColor: Colors.black,
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
                            activeColor: Colors.black,
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
                    ],
                  ),
                ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //todo:navigation to login
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ));
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: 'Already account? ',
                                            ),
                                            TextSpan(
                                                text: 'login',
                                                style: TextStyle(
                                                    color: textColor))
                                          ]),
                                    ),
                                  ),
                                  AppButton().appButton(
                                    small: true,
                                    text: "Continue",
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        _manager
                                            .register(User(
                                                id: 1,
                                                name: _nameCotroler.text,
                                                phone:
                                                    _phoneNumberCOntroller.text,
                                                email: _emailController.text,
                                                gender: 'male',
                                                paymentId: null,
                                                dob: null))
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(
                                                          fromRegistration:
                                                              true),
                                                )));
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
        ));
  }

  void showLoginFailMessage(context, manager) {
    Future.delayed(Duration(seconds: 1), () {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(manager.errorText ?? defaultloginError)));
    });
  }
}
