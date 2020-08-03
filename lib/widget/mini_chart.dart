import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutteriu_covid19/helper/helper.dart';

class MiniChart extends StatelessWidget {
  final List<String> label;
  final List<int> value;
  final List<Color> gradientColors = [
    Color(0xFFf6c59c),
    Color(0xFFed8a39),
  ];
  MiniChart({this.label, this.value});
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
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexs) {
          return spotIndexs.map((e) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.black12,
                strokeWidth: 1,
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.deepOrange,
                  );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black12,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '${label[flSpot.x.toInt()]} \n${flSpot.y}',
                  TextStyle(
                    color: Colors.white,
                  ),
                );
              }).toList();
            }),
      ),
      extraLinesData: ExtraLinesData(horizontalLines: [
        HorizontalLine(
          y: 0.5,
          color: Colors.deepOrange.withOpacity(0.8),
          strokeWidth: 0.5,
          dashArray: [20, 2],
        ),
      ]),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
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
            fontSize: 12,
          ),
          getTitles: (value) {
            return label[value.toInt()];
          },
          margin: 10,
        ),
        leftTitles: SideTitles(
          interval: vInterval,
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            var label;
            if (value >= 1000000)
              label = (value.toInt() / 1000000).toStringAsFixed(2) + "m";
            else if (value >= 1000)
              label = (value.toInt() ~/ 1000).toString() + "k";
            else
              label = Helper.numberFormat(value.toInt());
            return label;
          },
          reservedSize: 40,
          margin: 10,
        ),
      ),
      borderData: FlBorderData(
        show: false,
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
          barWidth: 10,
          isStrokeCapRound: true,
          dotData: FlDotData(
              show: true,
              checkToShowDot: (spots, barData) {
                return spots.x != 0 && spots.x != 7;
              }),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.2)).toList(),
          ),
        ),
      ],
    );
  }
}
