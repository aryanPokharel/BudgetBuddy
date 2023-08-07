import 'package:budget_buddy/Constants/FormatDate.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class FlLineGraph extends StatefulWidget {
  const FlLineGraph({super.key});

  @override
  State<FlLineGraph> createState() => _FlLineGraphState();
}

class _FlLineGraphState extends State<FlLineGraph> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;
    List<FlSpot> expenseSpots = [];
    List<FlSpot> incomeSpots = [];

    for (var transaction in transactionList) {
      if (transaction['type'] == 'Expense') {
        print(stringToDate(transaction['dateTime']).day);
        expenseSpots.add(FlSpot(
            double.parse(stringToDate(transaction['dateTime']).day.toString()),
            double.parse(transaction['amount'])));
      } else {
        incomeSpots.add(FlSpot(
            double.parse(stringToDate(transaction['dateTime']).day.toString()),
            double.parse(transaction['amount'])));
      }
    }
    return SizedBox(
      height: 400,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: expenseSpots,
              color: Colors.red,
            ),
            LineChartBarData(
              spots: incomeSpots,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
