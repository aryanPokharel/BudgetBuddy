import 'package:budget_buddy/Constants/ConstantValues.dart';
import 'package:budget_buddy/Constants/DancingDoge.dart';
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

// We need to call the expenseCategoryTypesTitles function from the StateProvider class

class _FlBarGraphState extends State<FlBarGraph> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;

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
    dynamic highestExpenseAmount = 0;
    dynamic highestIncomeAmount = 0;

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
          x: k,
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
    return (transactionList.length < 1)
        ? SizedBox(
            height: 300,
            child: DancingDoge(),
          )
        : Column(
            children: [
              Text(
                widget.type == "Expense"
                    ? "Expense Breakdown"
                    : "Income Breakdown",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              ((widget.type == "Expense" && expenseCategoryTypes.length < 1) ||
                      (widget.type == "Income" &&
                          incomeCategoryTypes.length < 1))
                  ? SizedBox(
                      height: 300,
                      child: DancingDoge(),
                    )
                  : SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: widget.type == "Expense"
                              ? highestExpenseAmount +
                                  (highestExpenseAmount * 0.1)
                              : highestIncomeAmount +
                                  (highestIncomeAmount * 0.1),
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
