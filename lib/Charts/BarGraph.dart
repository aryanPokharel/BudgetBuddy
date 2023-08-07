import 'package:budget_buddy/Constants/ColorList.dart';
import 'package:budget_buddy/Constants/TryParseDouble.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class FlBarGraph extends StatefulWidget {
  final type;

  const FlBarGraph({required this.type, super.key});

  @override
  State<FlBarGraph> createState() => _FlBarGraphState();
}

class _FlBarGraphState extends State<FlBarGraph> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;
    // Bar graph data entry
    List<BarChartGroupData> expenseBarGraphData = [];
    List<BarChartGroupData> incomeBarGraphData = [];
    List<Map<String, dynamic>> expenseCategoryTypes = [];
    List<Map<String, dynamic>> incomeCategoryTypes = [];
    var highestExpenseAmount = 0.0;
    var highestIncomeAmount = 0.0;
    for (var transaction in transactionList) {
      if (transaction['type'] == 'Expense') {
        // For expense categories
        double expenseCategoryTotalAmount =
            tryParseDouble(transaction['amount']);
        if (expenseCategoryTypes.isEmpty) {
          expenseCategoryTypes.add({
            "id": transaction['category'],
            "totalAmount": tryParseDouble(transaction['amount'].toString())
          });
        } else {
          bool found = false;
          for (var category in expenseCategoryTypes) {
            if (transaction['category'] != category['id']) {
              found = false;
            } else {
              found = true;
              category['totalAmount'] +=
                  tryParseDouble(transaction['amount'].toString());
            }
          }
          if (!found) {
            expenseCategoryTypes.add(
              {
                "id": transaction['category'],
                "totalAmount": expenseCategoryTotalAmount
              },
            );
          }
        }
      } else {
        // For income categories
        double incomeCategoryTotalAmount =
            tryParseDouble(transaction['amount']);
        if (incomeCategoryTypes.isEmpty) {
          incomeCategoryTypes.add({
            "id": transaction['category'],
            "totalAmount": tryParseDouble(transaction['amount'].toString())
          });
        } else {
          bool found = false;
          for (var category in incomeCategoryTypes) {
            if (transaction['category'] != category['id']) {
              found = false;
            } else {
              found = true;
              category['totalAmount'] +=
                  tryParseDouble(transaction['amount'].toString());
            }
          }
          if (!found) {
            incomeCategoryTypes.add(
              {
                "id": transaction['category'],
                "totalAmount": incomeCategoryTotalAmount
              },
            );
          }
        }
      }
    }

    for (var expenseCategory in expenseCategoryTypes) {
      if (expenseCategory['totalAmount'] > highestExpenseAmount) {
        highestExpenseAmount = expenseCategory['totalAmount'];
      }
    }

    for (var incomeCategory in incomeCategoryTypes) {
      if (incomeCategory['totalAmount'] > highestIncomeAmount) {
        highestIncomeAmount = incomeCategory['totalAmount'];
      }
    }

    int i = 0;
    for (var expenseCategory in expenseCategoryTypes) {
      expenseBarGraphData.add(
        BarChartGroupData(
          x: expenseCategory['id'],
          barRods: [
            BarChartRodData(
              toY: expenseCategory['totalAmount'],
              color: appThemeColors[i],
              width: 16,
            ),
          ],
        ),
      );
      i++;
    }

    int j = 0;
    for (var incomeCategory in incomeCategoryTypes) {
      incomeBarGraphData.add(
        BarChartGroupData(
          x: incomeCategory['id'],
          barRods: [
            BarChartRodData(
              toY: incomeCategory['totalAmount'],
              color: appThemeColors[j],
              width: 16,
            ),
          ],
        ),
      );
      j++;
    }

    List<Map<String, dynamic>> expenseIndices = [];

    for (var expenseCategory in expenseCategoryTypes) {
      expenseIndices.add(
        {
          "color":
              appThemeColors[expenseCategoryTypes.indexOf(expenseCategory)],
          "title": expenseCategory['id']
        },
      );
    }

    List<Map<String, dynamic>> incomeIndices = [];
    for (var incomeCategory in incomeCategoryTypes) {
      incomeIndices.add(
        {
          "color": appThemeColors[incomeCategoryTypes.indexOf(incomeCategory)],
          "title": incomeCategory['id']
        },
      );
    }
    return Column(
      children: [
        Text(
          widget.type == "Expense" ? "Expense Breakdown" : "Income Breakdown",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: widget.type == "Expense"
                  ? highestExpenseAmount + 100
                  : highestIncomeAmount + 100,
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              barGroups: widget.type == "Expense"
                  ? expenseBarGraphData
                  : incomeBarGraphData,
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
                for (int i = 0;
                    i <
                        (widget.type == "Expense"
                            ? expenseIndices.length
                            : incomeIndices.length);
                    i++)
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: (widget.type == "Expense"
                            ? expenseIndices[i]["color"]
                            : incomeIndices[i]["color"]),
                      ),
                      SizedBox(width: 4),
                      i == 0
                          ? Text(
                              "${(widget.type == "Expense" ? expenseIndices : incomeIndices)[i]["title"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              "${(widget.type == "Expense" ? expenseIndices : incomeIndices)[i]["title"]}",
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
