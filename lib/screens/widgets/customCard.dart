import 'package:flutter/material.dart';
import 'package:rideon/config/constant.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key key,
    this.color,
    @required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: color ?? Constant.cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ));
  }
}
