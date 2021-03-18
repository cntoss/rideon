import 'package:flutter/material.dart';
import 'package:rideon/screens/pooling/carPoolingStart.dart';

import 'parcelScreen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_car),
                  child: Text("Carpooling"),
                ),
                Tab(
                  icon: Icon(Icons.card_giftcard_rounded),
                  child: Text("Parcel"),
                )
              ],
            ),
            elevation: 0,
            pinned: true,
            floating: true,
            snap: false,
            expandedHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Service'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                        height: height(context),
                        child: TabBarView(
                          children: [
                            CarPoolingFirst(),
                            ParcelScreen(),
                          ],
                        ),
                      );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    ));
  }

  height(context) {
    var mq = MediaQuery.of(context);
    return mq.size.height - mq.padding.top - 60 - 48;
  }
}
