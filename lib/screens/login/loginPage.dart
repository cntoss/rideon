import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/screens/home/homePageWarper.dart';
import 'package:rideon/screens/login/forgotPassword.dart';
import 'package:rideon/screens/login/registerscreen.dart';
import 'package:rideon/screens/widgets/appButton.dart';
import 'package:rideon/screens/widgets/customCard.dart';
import 'package:rideon/services/login/loginManager.dart';
import 'package:animations/animations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneNumberCOntroller;
  TextEditingController _passwordCOntroller;
  final _formKey = GlobalKey<FormState>();
  FocusNode _pwFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumberCOntroller = TextEditingController(text: "");
    _passwordCOntroller = TextEditingController(text: "");
    _pwFocus = FocusNode();
  }

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          children: [
            Image.asset(
              'assets/logo1.png',
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.height,
            ),
            Form(
              key: _formKey,
              child: CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: _phoneNumberCOntroller,
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
                            Icons.person,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          errorStyle: Constant.errorStyle,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Colors.green)),
                          counterText: '',
                          hintText: "Phone Number",
                        ),
                      ),
                    ),
                    _PasswordFieldWidget(
                        controller: _passwordCOntroller, node: _pwFocus),
                    OpenContainer(
                      closedElevation: 0,
                      openColor: Theme.of(context).scaffoldBackgroundColor,
                      closedColor: Constant.cardColor,
                      openBuilder: (BuildContext context,
                          void Function({Object returnValue}) action) {
                        return Center(child: ForgotPassword());
                      },
                      closedBuilder:
                          (BuildContext context, void Function() action) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: Constant.textColor, fontSize: 16),
                            ),
                          ),
                        );
                      },
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
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Registration(),
                                      ));
                                },
                                child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Not account? ',
                                        ),
                                        TextSpan(
                                            text: 'sign up',
                                            style: TextStyle(
                                                color: Constant.textColor))
                                      ]),
                                ),
                              ),
                              AppButton().appButton(
                                small: true,
                                text: "Login",
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate()) {
                                    _manager.login(phone: _phoneNumberCOntroller.text, password: _phoneNumberCOntroller.text);
                                         Navigator.pushReplacementNamed(context, '/home');

                                   /*  Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomePageWrapper(),
                                        )); */
                                  }
                                },
                              ),
                            ],
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
}

class _PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode node;

  const _PasswordFieldWidget({Key key, this.controller, this.node})
      : super(key: key);

  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<_PasswordFieldWidget> {
  bool hidden = true;
  bool showingEye = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          onChanged: (v) {
            if (!showingEye && v.trim().length > 1)
              setState(() {
                showingEye = true;
              });
            else if (showingEye && v.trim().length < 1)
              setState(() {
                showingEye = false;
              });
          },
          focusNode: widget.node,
          controller: widget.controller,
          obscureText: hidden,
          validator: (s) {
            if (s.trim().length < 6)
              return Constant.passwordValidationError;
            else
              return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            errorStyle: Constant.errorStyle,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.green)),
            hintText: "Password",
          ),
        ),
        if (widget.controller.text.trim().length > 0)
          Positioned(
            top: 6,
            right: 4,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    hidden = !hidden;
                  });
                },
                child: Material(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withOpacity(.02),
                    child: SizedBox(
                        height: 44,
                        width: 50,
                        child: Icon(
                          hidden ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                        )))),
          ),
      ],
    );
  }
}
