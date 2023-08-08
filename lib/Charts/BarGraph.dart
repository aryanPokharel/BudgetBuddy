import 'package:budget_buddy/Constants/ColorList.dart';
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
    List<dynamic> expenseCategoryTypes =
        Provider.of<StateProvider>(context).expenseCategoryTypes;
    List<dynamic> incomeCategoryTypes =
        Provider.of<StateProvider>(context).incomeCategoryTypes;

    var expenseCateogoryTypesTitles =
        Provider.of<StateProvider>(context).expenseCategoryTypesTitles;
    var incomeCateogoryTypesTitles =
        Provider.of<StateProvider>(context).incomeCategoryTypesTitles;
    var highestExpenseAmount = 0.0;
    var highestIncomeAmount = 0.0;

    int i = 0;
    for (var expenseCategory in expenseCategoryTypes) {
      if (expenseCategory['totalAmount'] > highestExpenseAmount) {
        highestExpenseAmount = expenseCategory['totalAmount'];
      }
      i++;
    }

    for (var incomeCategory in incomeCategoryTypes) {
      if (incomeCategory['totalAmount'] > highestIncomeAmount) {
        highestIncomeAmount = incomeCategory['totalAmount'];
      }
    }

    int j = 0;
    for (var expenseCategory in expenseCategoryTypes) {
      expenseBarGraphData.add(
        BarChartGroupData(
          x: expenseCategory['id'],
          barRods: [
            BarChartRodData(
              toY: expenseCategory['totalAmount'],
              color: appThemeColors[j],
              width: 16,
            ),
          ],
        ),
      );
      j++;
    }

    int k = 0;
    for (var incomeCategory in incomeCategoryTypes) {
      incomeBarGraphData.add(
        BarChartGroupData(
          x: incomeCategory['id'],
          barRods: [
            BarChartRodData(
              toY: incomeCategory['totalAmount'],
              color: appThemeColors[k],
              width: 16,
            ),
          ],
        ),
      );
      k++;
    }

    List<Map<String, dynamic>> expenseIndices = [];
    int l = 0;
    for (var expenseCategory in expenseCategoryTypes) {
      expenseIndices.add(
        {
          "color":
              appThemeColors[expenseCategoryTypes.indexOf(expenseCategory)],
          "title": expenseCateogoryTypesTitles[l]
        },
      );
      l++;
    }

    List<Map<String, dynamic>> incomeIndices = [];
    int m = 0;
    for (var incomeCategory in incomeCategoryTypes) {
      incomeIndices.add(
        {
          "color": appThemeColors[incomeCategoryTypes.indexOf(incomeCategory)],
          "title": incomeCateogoryTypesTitles[m]
        },
      );
      m++;
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
