import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title:Text('History Screen'),automaticallyImplyLeading: false),
          body: Container(
        child: Center(child: Text('History')),
        
      ),
    );
  }
}