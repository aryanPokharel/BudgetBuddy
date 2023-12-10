import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class FlLineGraph extends StatefulWidget {
  final insightType;
  const FlLineGraph({this.insightType, super.key});

  @override
  State<FlLineGraph> createState() => _FlLineGraphState();
}

class _FlLineGraphState extends State<FlLineGraph> {
  late List<dynamic> transactionList;
  @override
  Widget build(BuildContext context) {
    if (widget.insightType == "Monthly") {
      transactionList =
          Provider.of<StateProvider>(context).thisMonthTransactions;
    } else {
      transactionList = Provider.of<StateProvider>(context).transactionList;
    }

    List<FlSpot> expenseSpots = [];
    List<FlSpot> incomeSpots = [];

    double totalExpenses = 0;
    double totalIncome = 0;

    List expenseDates = [];
    List incomeDates = [];
    for (var transaction in transactionList) {
      if (transaction['type'] == 'Expense') {
        var transactionDay = DateTime.parse(transaction['dateTime']).day;
        var existingExpenseDate = expenseDates.firstWhere(
          (expenseDate) => expenseDate['day'] == transactionDay,
          orElse: () => null,
        );

        if (existingExpenseDate != null) {
          existingExpenseDate['amount'] += double.parse(transaction['amount']);
        } else {
          expenseDates.add({
            "day": transactionDay,
            "amount": double.parse(transaction['amount'])
          });
        }

        totalExpenses += double.parse(transaction['amount']);
      } else {
        var transactionDay = DateTime.parse(transaction['dateTime']).day;
        var existingIncomeDate = incomeDates.firstWhere(
          (incomeDate) => incomeDate['day'] == transactionDay,
          orElse: () => null,
        );
        if (existingIncomeDate != null) {
          existingIncomeDate['amount'] += double.parse(transaction['amount']);
        } else {
          incomeDates.add({
            "day": transactionDay,
            "amount": double.parse(transaction['amount'])
          });
        }
        totalIncome += double.parse(transaction['amount']);
      }
    }

    for (var expenseDate in expenseDates) {
      expenseSpots.add(
        FlSpot(
          double.parse(expenseDate['day'].toString()),
          double.parse(expenseDate['amount'].toString()),
        ),
      );
    }

    for (var incomeDate in incomeDates) {
      incomeSpots.add(
        FlSpot(
          double.parse(incomeDate['day'].toString()),
          double.parse(incomeDate['amount'].toString()),
        ),
      );
    }

    List<Map<String, dynamic>> data = [
      {"color": Colors.green, "title": "Income"},
      {"color": Colors.red, "title": "Expense"},
    ];

    return (transactionList.length < 1)
        ? SizedBox(
            height: 300,
            child: EmptyListWidget(),
          )
        : Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Income vs Expense",
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
                child: LineChart(
                  LineChartData(
                    minY: totalIncome > totalExpenses
                        ? -(totalExpenses * 0.1)
                        : -(totalIncome * 0.1),
                    maxY: totalIncome > totalExpenses
                        ? totalIncome + (totalIncome * 0.1)
                        : totalExpenses + (totalExpenses * 0.1),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                    ),
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
