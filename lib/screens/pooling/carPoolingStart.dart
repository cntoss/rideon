import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rideon/config/constant.dart';
import 'package:rideon/models/pooling/counterModel.dart';
import 'package:rideon/services/utils/extension.dart';

class CarPoolingFirst extends StatefulWidget {
  @override
  _CarPoolingFirstState createState() => _CarPoolingFirstState();
}

class _CarPoolingFirstState extends State<CarPoolingFirst> {
  TextEditingController _fromAddress = TextEditingController(text: '');
  TextEditingController _toAddress = TextEditingController(text: '');

  DateTime _selectedDate;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _passenger = TextEditingController();

  List<bool> _isFilled = [true, true, false];

  @override
  Widget build(BuildContext context) {
    var passenger = Provider.of<PassengerCounter>(context);


    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          child: Column(children: [
            Text('Find a ride', style: TextStyle(fontSize: 30)),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _fromAddress,
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
                      hintText: "Leaving Form",
                      labelStyle: Constant.whiteText),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _toAddress,
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
                    hintText: "Going to",
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(_dateController.text == ''
                      ? 'Today'
                      : _dateController.text),
                  onPressed: () => _selectDate(context),
                ),
                OpenContainer(
                  closedElevation: 0,
                  openColor: Theme.of(context).scaffoldBackgroundColor,
                  closedColor: Theme.of(context).scaffoldBackgroundColor,
                  openBuilder: (BuildContext context,
                      void Function({Object returnValue}) action) {
                    return Center(
                        child: PassengerScreen(
                      controller: _passenger,
                    ));
                  },
                  closedBuilder:
                      (BuildContext context, void Function() action) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                            passenger.value == 0
                                ? 'Passenger'
                                : passenger.value.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                wordSpacing: 2,
                                color: Colors.white,
                                letterSpacing: 2),
                          ),
                        );
                        /* child: Consumer<PassengerCounter>(
                          builder: (context, passenger, child) => Text(
                            passenger.value == 0
                                ? 'Passenger'
                                : passenger.value.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                wordSpacing: 2,
                                color: Colors.white,
                                letterSpacing: 2),
                          ),
                        ));
  */                 },
                ),
              ],
            ),
            Consumer<PassengerCounter>(
                builder: (context, passenger, child) =>
                    !_isFilled.contains(false) && passenger.value != 0
                        ? ElevatedButton(
                            child: Text('Search'),
                            onPressed: () {},
                          )
                        : Container())
          ]),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.tealAccent,
                onPrimary: Colors.white,
                surface: Colors.teal,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.green[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      setState(() {
        _dateController
          ..text = DateFormat.yMMMd().format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _dateController.text.length,
              affinity: TextAffinity.upstream));
        _isFilled[2] = true;
      });
    }
  }
}

class PassengerScreen extends StatefulWidget {
  final TextEditingController controller;
  PassengerScreen({this.controller});
  @override
  _PassengerScreenState createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  int countPassenger;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    countPassenger = widget.controller.text.isNullOrEmpty()
        ? 1
        : int.parse(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
        var passenger = Provider.of<PassengerCounter>(context);

    return  WillPopScope(
      onWillPop: () async {
       // var passenger = context.read<PassengerCounter>();
        if (passenger.value == 0) {
          passenger.increment();
        }
        return true;
      },
      child: Scaffold(
        body: Container(
            margin: EdgeInsets.only(
                left: 50,
                top: MediaQuery.of(context).size.height / 3,
                right: 50),
            child: Column(
              children: [
                Text(
                  'Select Number of seats to book',
                  style: Constant.titleWhite.copyWith(fontSize: 22),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: countPassenger > 1
                              ? Icon(Icons.remove_circle_outline_outlined)
                              : Icon(Icons.remove_circle),
                          iconSize: 50,
                          color: countPassenger > 1
                              ? Colors.blueGrey
                              : Colors.black38,
                          onPressed: () {
                           // var passenger = context.read<PassengerCounter>();
                            if (passenger.value > 1) {
                              passenger.decrement();
                            }
                          }),
                      /* Consumer<PassengerCounter>(
                          builder: (context, passenger, child) => Text(
                                passenger.value == 0
                                    ? '1'
                                    : passenger.value.toString(),
                                style: Constant.titleWhite,
                              )), */
                              Text(
                                passenger.value == 0
                                    ? '1'
                                    : passenger.value.toString(),
                                style: Constant.titleWhite,
                              ),
                      IconButton(
                          icon: countPassenger > 7
                              ? Icon(Icons.add_circle_rounded)
                              : Icon(Icons.add_circle_outline),
                          iconSize: 50,
                          color: countPassenger < 8
                              ? Colors.blueGrey
                              : Colors.black38,
                          onPressed: () {
                           // var passenger = context.read<PassengerCounter>();
                            if (passenger.value < 8) {
                              passenger.increment();
                            }
                          }),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () => _back(), child: Text('Continue'))
              ],
            )),
      ),
    );
  }

  _back() {
    setState(() {
      widget.controller.text = countPassenger.toString();
    });
    Navigator.pop(context);
  }
}
