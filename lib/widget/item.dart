import 'package:countup/countup.dart';
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final String label;
  final int value;

  final Color textColor;
  final Color valueColor;

  ItemContainer({
    this.label,
    this.textColor,
    this.valueColor,
    this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFf2f6fd),
      elevation: 14.0,
      shadowColor: valueColor,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Countup(
              separator: ',',
              begin: value / 9,
              end: value.toDouble(),
              style: TextStyle(
                fontSize: 26,
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
