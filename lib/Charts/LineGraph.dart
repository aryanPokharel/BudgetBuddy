import 'package:budget_buddy/Constants/FormatDate.dart';
import 'package:budget_buddy/Constants/LooksEmpty.dart';
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
        expenseSpots.add(
          FlSpot(
            double.parse(stringToDate(transaction['dateTime']).day.toString()),
            double.parse(
              transaction['amount'],
            ),
          ),
        );
      } else {
        incomeSpots.add(
          FlSpot(
            double.parse(stringToDate(transaction['dateTime']).day.toString()),
            double.parse(
              transaction['amount'],
            ),
          ),
        );
      }
    }

    List<Map<String, dynamic>> data = [
      {"color": Colors.green, "title": "Income"},
      {"color": Colors.red, "title": "Expense"},
    ];
    return Column(
      children: [
        Text(
          "Through The Month",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 400,
          child: transactionList.length > 0
              ? LineChart(
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
                )
              : EmptyListWidget(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < data.length; i++)
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: data[i]["color"],
                      ),
                      SizedBox(width: 4),
                      i == 0
                          ? Text(
                              "${data[i]["title"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              "${data[i]["title"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ],
                  ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
