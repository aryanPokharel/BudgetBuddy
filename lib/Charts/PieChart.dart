import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ShowPieChart extends StatefulWidget {
  final Map<String, double> pieData;
  final String pieTitle;

  const ShowPieChart({Key? key, required this.pieData, required this.pieTitle})
      : super(key: key);

  @override
  State<ShowPieChart> createState() => _ShowPieChartState();
}

class _ShowPieChartState extends State<ShowPieChart> {
  Map<String, double> defaultPieData = {"Empty": 0};

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: widget.pieData.isEmpty ? defaultPieData : widget.pieData,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 42,
      chartRadius: MediaQuery.of(context).size.width / 1.4,
      colorList: widget.pieData.isEmpty
          ? [const Color.fromARGB(255, 177, 150, 150)]
          : [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.deepOrange,
              Colors.deepPurple,
              Colors.yellow,
              Colors.purple,
              Colors.blueGrey,
              Colors.black45,
              Colors.white,
              Colors.amberAccent
            ],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 62,
      centerText: widget.pieTitle,
      centerTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        // legendShape: _BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: true,
        decimalPlaces: 1,
      ),
    );
  }
}