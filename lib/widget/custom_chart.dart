import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;
import 'package:flutter/material.dart';
import 'package:flutteriu_covid19/helper/helper.dart';
import 'package:flutteriu_covid19/model/data_date_line_chart_model.dart';
import 'package:flutteriu_covid19/widget/item_type.dart';
import 'package:intl/intl.dart';

class CustomCasesChart extends StatefulWidget {
  final List<DateLineChartModel> lineCases;
  final List<DateLineChartModel> lineDeath;
  final List<DateLineChartModel> lineRecovered;
  final bool animate;
  static List selectedDatum;
  CustomCasesChart({
    this.animate,
    this.lineCases,
    this.lineDeath,
    this.lineRecovered,
  });

  @override
  _CustomCasesChartState createState() => _CustomCasesChartState();
}

class _CustomCasesChartState extends State<CustomCasesChart> {
  bool activeDeath;
  bool activeCases;
  bool activeRecovered;
  final simpleCurrencyFormatter =
      new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
    NumberFormat.compact(locale: 'en'),
  );
  @override
  void initState() {
    super.initState();
    activeCases = true;
    activeDeath = true;
    activeRecovered = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ItemTypeChart(
              name: 'Confirmed',
              color: Color(0xFFffb259),
              active: activeCases,
              onTap: () {
                setState(() {
                  activeCases = !activeCases;
                });
              },
            ),
            ItemTypeChart(
              name: 'Recovered',
              color: Color(0xFF4cd97b),
              active: activeRecovered,
              onTap: () {
                setState(() {
                  activeRecovered = !activeRecovered;
                });
              },
            ),
            ItemTypeChart(
              name: 'Deaths',
              color: Color(0xFFff5959),
              active: activeDeath,
              onTap: () {
                setState(() {
                  activeDeath = !activeDeath;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: charts.TimeSeriesChart(
            createLineChart(),
            defaultRenderer: charts.LineRendererConfig(
              roundEndCaps: true,
              includeArea: true,
              stacked: true,
              includePoints: true,
            ),
            domainAxis: charts.DateTimeAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 14, // size in Pts.
                    fontWeight: 'charts.MaterialFontWeight.bold',
                    color: charts.ColorUtil.fromDartColor(
                      Color(0xFF616265),
                    ),
                  ),

                  // Change the line colors to match text color.
                  lineStyle: charts.LineStyleSpec(
                      thickness: 0,
                      color: charts.MaterialPalette.gray.shadeDefault)),
              tickProviderSpec:
                  charts.AutoDateTimeTickProviderSpec(includeTime: false),
              tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                day: charts.TimeFormatterSpec(
                  format: 'd/MM',
                  transitionFormat: 'dd/MM',
                ),
              ),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  fontWeight: 'Bold',
                  fontSize: 12,
                  color: charts.ColorUtil.fromDartColor(Color(0xFF616265)),
                ),
                lineStyle: charts.LineStyleSpec(
                  thickness: 0,
                  color: charts.MaterialPalette.gray.shadeDefault,
                ),
              ),
              showAxisLine: true,
              tickFormatterSpec: simpleCurrencyFormatter,
              tickProviderSpec:
                  charts.BasicNumericTickProviderSpec(zeroBound: true),
            ),
            animate: widget.animate,
            selectionModels: [
              charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model) {
                if (model.hasDatumSelection)
                  CustomCasesChart.selectedDatum = [];
                model.selectedDatum.forEach((charts.SeriesDatum datumPair) {
                  var time = Helper.dateTimeFormat(datumPair.datum.timeStamp);
                  var value = Helper.numberFormat(datumPair.datum.value);
                  CustomCasesChart.selectedDatum.add({
                    'time': '$time',
                    'text': '$value ',
                    'color': datumPair.series.colorFn(0),
                  });
                });
              })
            ],
            behaviors: [
              charts.LinePointHighlighter(
                symbolRenderer: CustomCircleSymbolRenderer(size: size),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<charts.Series<DateLineChartModel, DateTime>> createLineChart() {
    final data = widget.lineCases;
    final dataDeath = widget.lineDeath;
    final dataRecovered = widget.lineRecovered;
//https://stackoverflow.com/questions/56437850/how-to-apply-linear-gradient-in-flutter-charts
    return [
      if (activeDeath) ...[
        charts.Series<DateLineChartModel, DateTime>(
          id: "Death",
          data: dataDeath,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFff5959)),
          domainFn: (DateLineChartModel lineChart, _) => lineChart.timeStamp,
          measureFn: (DateLineChartModel lineChart, _) => lineChart.value,
        ),
      ],
      if (activeRecovered) ...[
        charts.Series<DateLineChartModel, DateTime>(
          id: "Recovered",
          data: dataRecovered,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF4cd97b)),
          domainFn: (DateLineChartModel lineChart, _) => lineChart.timeStamp,
          measureFn: (DateLineChartModel lineChart, _) => lineChart.value,
        ),
      ],
      if (activeCases) ...[
        charts.Series<DateLineChartModel, DateTime>(
          id: "Cases",
          data: data,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFFffb259)),
          domainFn: (DateLineChartModel lineChart, _) => lineChart.timeStamp,
          measureFn: (DateLineChartModel lineChart, _) => lineChart.value,
        ),
      ]
    ];
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  final size;
  CustomCircleSymbolRenderer({this.size});

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: charts.Color.white,
        strokeColor: charts.Color.black,
        strokeWidthPx: 1);
    List tooltips = CustomCasesChart.selectedDatum;
    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 12;

    if (tooltips != null && tooltips.length > 0) {
      var valueHeight;
      if (tooltips[0] != null && tooltips.length == 1) {
        valueHeight = 26;
      } else if (tooltips[1] != null && tooltips.length == 2) {
        valueHeight = 22;
      } else {
        valueHeight = 16;
      }
      num rectWidth = 100;
      num rectHeight = bounds.height + valueHeight + (tooltips.length - 1) * 20;
      num left = bounds.left > (size?.width ?? 300) / 2
          ? (bounds.left > size?.width / 4
              ? bounds.left - rectWidth
              : bounds.left - rectWidth / 2)
          : bounds.left - 40;
      canvas.drawRRect(
        Rectangle(left, -5, rectWidth, rectHeight),
        fill: charts.Color.fromHex(code: '#6666666'),
        radius: 10.0,
        roundBottomRight: true,
        roundBottomLeft: true,
        roundTopLeft: true,
        roundTopRight: true,
      );
      chartsTextStyle.TextStyle textStyle = chartsTextStyle.TextStyle();
      textStyle.color = charts.Color.white;
      textStyle.fontSize = 13;

      canvas.drawText(
          chartsTextElement.TextElement(tooltips[0]['time'], style: textStyle),
          left.round() + 18,
          0);
      for (int i = 0; i < tooltips.length; i++) {
        canvas.drawPoint(
          point: Point(left.round() + 10, i * 15 + 21),
          radius: 3,
          fill: tooltips[i]['color'],
          strokeWidthPx: 1,
        );
        chartsTextStyle.TextStyle textStyle = chartsTextStyle.TextStyle();
        textStyle.color = charts.Color.white;
        textStyle.fontSize = 13;
        canvas.drawText(
            chartsTextElement.TextElement(tooltips[i]['text'],
                style: textStyle),
            left.round() + 18,
            i * 15 + 15);
      }
    }
  }
}
