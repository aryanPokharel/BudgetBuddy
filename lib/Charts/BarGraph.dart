import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FlBarGraph extends StatefulWidget {
  final barGraphData;
  final highestAmount;

  const FlBarGraph(
      {required this.barGraphData, required this.highestAmount, super.key});

  @override
  State<FlBarGraph> createState() => _FlBarGraphState();
}

class _FlBarGraphState extends State<FlBarGraph> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: widget.highestAmount + 100,
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          barGroups: widget.barGraphData,
        ),
      ),
    );
  }
}
