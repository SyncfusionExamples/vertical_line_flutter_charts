import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_timer) {
      _start = _start.add(const Duration(minutes: 1));
      _end = _end.add(const Duration(minutes: 1));
      setState(() {});
    });
  }

  late List<ChartData> _chartData;
  // ignore: unused_field
  Timer? _timer;

  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();

  @override
  void initState() {
    _chartData = updateData(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: SizedBox(
                height: 200,
                child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(plotBands: <PlotBand>[
                      PlotBand(
                          start: _start,
                          end: _end,
                          shouldRenderAboveSeries: true,
                          borderWidth: 3,
                          borderColor: Colors.red)
                    ]),
                    series: <ChartSeries<ChartData, DateTime>>[
                      ColumnSeries<ChartData, DateTime>(
                          borderRadius: BorderRadius.circular(3),
                          dataSource: _chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y)
                    ]))));
  }

  List<ChartData> updateData(DateTime now) {
    late List<ChartData> data = <ChartData>[];
    for (int i = 0; i < 12; i++) {
      i == 0
          ? data.add(ChartData(now, _getRandomInt(10, 50)))
          : data.add(ChartData(data.last.x.add(const Duration(hours: 1)),
              _getRandomInt(10, 50)));
    }
    return data;
  }

  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final num y;
}
