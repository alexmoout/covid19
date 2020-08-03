import 'package:flutter/material.dart';

class ItemTypeChart extends StatefulWidget {
  final Function onTap;
  final bool active;
  final String name;
  final Color color;
  ItemTypeChart({this.onTap, this.active, this.name, this.color});
  @override
  _ItemTypeChartState createState() => _ItemTypeChartState();
}

class _ItemTypeChartState extends State<ItemTypeChart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 20,
        child: Material(
          color: Color(0xFF232531),
          shadowColor: widget.active ? widget.color : Colors.grey,
          borderRadius: BorderRadius.circular(
            10,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 40,
                  height: 3,
                  color: widget.active ? widget.color : Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFd4d4d7),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          elevation: 5,
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
