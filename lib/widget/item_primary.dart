import 'package:flutter/material.dart';

class ItemPrimaryContainer extends StatelessWidget {
  final String label;
  final int value;
  final Color textColor;
  final Color valueColor;
  final Widget widget;

  ItemPrimaryContainer({
    this.label,
    this.textColor,
    this.valueColor,
    this.value,
    this.widget,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
//        gradient: LinearGradient(
//            begin: Alignment.bottomLeft,
//            end: Alignment.topRight,
//            colors: [Colors.white, Color(0xFFfeecde), Color(0xFFfde0c9)]),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget,
          ],
        ),
      ),
    );
  }
}
