import 'package:flutter/material.dart';

class ConfirmTextWidget extends StatelessWidget {
  final String name;
  final String values;
  const ConfirmTextWidget(this.name, this.values);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(name),
          ),
          Flexible(
            child: Text(
              values,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
