import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final List<Widget> children;
  final double? opacity;
  ListCard({required this.children, this.opacity});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Opacity(
          opacity: opacity ?? 1,
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
