import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyChat extends StatefulWidget {
  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChat> {
  late List<charts.Series<EWasteData, String>> _seriesData;

  @override
  void initState() {
    super.initState();
    _seriesData = _createSampleData();
  }

  List<charts.Series<EWasteData, String>> _createSampleData() {
    final data = [
      EWasteData('2017', 44700),
      EWasteData('2018', 49800),
      EWasteData('2019', 53600),
      EWasteData('2020', 53600),
      EWasteData('2021', 57000),
    ];

    return [
      charts.Series<EWasteData, String>(
        id: 'E-waste',
        domainFn: (EWasteData sales, _) => sales.year,
        measureFn: (EWasteData sales, _) => sales.value,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Colors.green.shade300), // Set the bar color to green
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors
            .greenAccent
            .shade700), // Set a slightly lighter shade for the bar fill color
        labelAccessorFn: (EWasteData sales, _) => '${sales.value}',
        insideLabelStyleAccessorFn: (_, __) {
          final color = charts.MaterialPalette.white;
          return charts.TextStyleSpec(color: color);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-waste Bar Chart'),
      ),
      body: Center(
        child: Container(
          height: 400.0,
          width: 300.0,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: charts.BarChart(
              _seriesData,
              animate: true,
              barGroupingType: charts.BarGroupingType.grouped,
              behaviors: [
                charts.SeriesLegend(),
                charts.ChartTitle(
                  'Years',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                ),
                charts.ChartTitle(
                  'E-waste (in 10,000s metric tons)',
                  behaviorPosition: charts.BehaviorPosition.start,
                ),
                charts.SlidingViewport(),
                charts.PanBehavior(),
              ],
              animationDuration: Duration(seconds: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class EWasteData {
  final String year;
  final int value;

  EWasteData(this.year, this.value);
}
