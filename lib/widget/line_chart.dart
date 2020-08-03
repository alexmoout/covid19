import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutteriu_covid19/helper/helper.dart';
import 'package:flutteriu_covid19/model/date_line_chart_model.dart';

class LineChartDataWidget extends StatelessWidget {
  final List<LineChartModel> listData;
  final List<String> label;
  final List<int> value;
  final List<Color> gradientColors = [
    Color(0xFFf88e86),
    Color(0xFFf5564a),
    Color(0xFFc3362b),
  ];
  LineChartDataWidget({this.listData, this.label, this.value});
  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(),
      swapAnimationDuration: Duration(seconds: 3),
    );
  }

  LineChartData mainData() {
    var xLabels = label;
    var values = value;
    double vInterval = values.reduce(max).toDouble() / 8;
    double hInterval = xLabels.length.toDouble() / 4;
    print(
      '${vInterval.toString()} ${hInterval.toString()}',
    );
    List<FlSpot> spots = [];
    for (int i = 0; i < value.length; i++) {
      spots.add(FlSpot(i.toDouble(), value[i].toDouble()));
    }

    FlLine gridLine = FlLine(
      color: Color(0xff37434d),
      strokeWidth: 1,
    );

    FlLine nullLine = FlLine(
      color: Colors.transparent,
      strokeWidth: 10,
    );

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return gridLine;
        },
        getDrawingVerticalLine: (value) {
          if (value % hInterval < 5) return gridLine;
          return nullLine;
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          interval: hInterval,
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            return label[value.toInt()];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          interval: vInterval,
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            var label;
            if (value >= 1000000)
              label = (value.toInt() / 1000000).toStringAsFixed(2) + " Triệu";
            else if (value >= 1000)
              label = (value.toInt() ~/ 1000).toString() + "K";
            else
              label = Helper.numberFormat(value.toInt());
            return label;
          },
          reservedSize: 100,
          margin: 10,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Color(0xff37434d),
          width: 1,
        ),
      ),
      minX: 0,
      maxX: (value.length - 1).toDouble(),
      minY: 0,
      maxY: value.reduce(max).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
