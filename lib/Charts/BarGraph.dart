import 'package:budget_buddy/Constants/ColorList.dart';
import 'package:budget_buddy/Constants/DancingDoge.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class FlBarGraph extends StatefulWidget {
  final data;
  final type;

  const FlBarGraph({required this.data, required this.type, super.key});

  @override
  State<FlBarGraph> createState() => _FlBarGraphState();
}

class _FlBarGraphState extends State<FlBarGraph> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;

// For monthly insights
    dynamic selectedMonth = Provider.of<StateProvider>(context).selectedMonth;
    List<dynamic> thisMonthTransactions =
        Provider.of<StateProvider>(context).thisMonthTransactionList;

    List<BarChartGroupData> expenseBarGraphData = [];
    List<BarChartGroupData> incomeBarGraphData = [];

    List<dynamic> expenseCategoryTypes =
        Provider.of<StateProvider>(context).expenseCategoryTypes;
    List<dynamic> incomeCategoryTypes =
        Provider.of<StateProvider>(context).incomeCategoryTypes;

// For monthly insights
    List<BarChartGroupData> thisMonthExpenseBarGraphData = [];
    List<BarChartGroupData> thisMonthIncomeBarGraphData = [];

    List<dynamic> thisMonthExpenseCategoryTypes =
        Provider.of<StateProvider>(context).thisMonthExpenseCategoryTypes;

    List<dynamic> thisMonthIncomeCategoryTypes =
        Provider.of<StateProvider>(context).thisMonthIncomeCategoryTypes;

    var expenseCateogoryTypesTitles =
        Provider.of<StateProvider>(context).expenseCategoryTypesTitles;
    var incomeCateogoryTypesTitles =
        Provider.of<StateProvider>(context).incomeCategoryTypesTitles;

// For monthly Insights
    var thisMonthExpenseCateogoryTypesTitles =
        Provider.of<StateProvider>(context).thisMonthExpenseCategoryTypesTitles;
    var thisMonthIncomeCateogoryTypesTitles =
        Provider.of<StateProvider>(context).thisMonthIncomeCategoryTypesTitles;

    var highestExpenseAmount = 0.0;
    var highestIncomeAmount = 0.0;

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
          x: j + 1,
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
          x: k + 1,
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
          "title": expenseCateogoryTypesTitles.isNotEmpty
              ? expenseCateogoryTypesTitles[l]
              : "No Title"
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
          "title": incomeCateogoryTypesTitles.isNotEmpty
              ? incomeCateogoryTypesTitles[m]
              : "No Title"
        },
      );
      m++;
    }

    // Doing the same calculation for this month data :
    var thisMonthHighestExpenseAmount = 0.0;
    var thisMonthHighestIncomeAmount = 0.0;

    for (var expenseCategory in thisMonthExpenseCategoryTypes) {
      if (expenseCategory['totalAmount'] > thisMonthHighestExpenseAmount) {
        thisMonthHighestExpenseAmount = expenseCategory['totalAmount'];
      }
    }

    for (var incomeCategory in incomeCategoryTypes) {
      if (incomeCategory['totalAmount'] > thisMonthHighestIncomeAmount) {
        thisMonthHighestIncomeAmount = incomeCategory['totalAmount'];
      }
    }

    int n = 0;
    for (var expenseCategory in thisMonthExpenseCategoryTypes) {
      thisMonthExpenseBarGraphData.add(
        BarChartGroupData(
          x: n + 1,
          barRods: [
            BarChartRodData(
              toY: expenseCategory['totalAmount'],
              color: appThemeColors[n],
              width: 16,
            ),
          ],
        ),
      );
      n++;
    }

    int o = 0;
    for (var incomeCategory in thisMonthIncomeCategoryTypes) {
      thisMonthIncomeBarGraphData.add(
        BarChartGroupData(
          x: o + 1,
          barRods: [
            BarChartRodData(
              toY: incomeCategory['totalAmount'],
              color: appThemeColors[o],
              width: 16,
            ),
          ],
        ),
      );
      o++;
    }

    List<Map<String, dynamic>> thisMonthExpenseIndices = [];
    int p = 0;
    for (var thisMonthExpenseCategory in thisMonthExpenseCategoryTypes) {
      thisMonthExpenseIndices.add(
        {
          "color": appThemeColors[
              thisMonthExpenseCategoryTypes.indexOf(thisMonthExpenseCategory)],
          "title": thisMonthExpenseCateogoryTypesTitles.isNotEmpty
              ? thisMonthExpenseCateogoryTypesTitles[p]
              : "N/A"
        },
      );
      p++;
    }

    List<Map<String, dynamic>> thisMonthIncomeIndices = [];
    int q = 0;
    for (var thisMonthIncomeCategory in thisMonthIncomeCategoryTypes) {
      thisMonthIncomeIndices.add(
        {
          "color": appThemeColors[
              thisMonthIncomeCategoryTypes.indexOf(thisMonthIncomeCategory)],
          "title": thisMonthIncomeCateogoryTypesTitles.isNotEmpty
              ? thisMonthIncomeCateogoryTypesTitles[q]
              : "N/A"
        },
      );
      q++;
    }

    return (!(widget.data)
        ? (transactionList.length < 1)
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
                  ((widget.type == "Expense" &&
                              expenseCategoryTypes.length < 1) ||
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
              )

        // Else, return Monthly Data
        : (thisMonthTransactions.length < 1)
            ? SizedBox(
                height: 300,
                child: Text("No Transactions this month"),
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
                  ((widget.type == "Expense" &&
                              thisMonthExpenseCategoryTypes.length < 1) ||
                          (widget.type == "Income" &&
                              thisMonthIncomeCategoryTypes.length < 1))
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
                                  ? thisMonthHighestExpenseAmount + 100
                                  : thisMonthHighestIncomeAmount + 100,
                              titlesData: FlTitlesData(show: true),
                              borderData: FlBorderData(show: true),
                              barGroups: widget.type == "Expense"
                                  ? thisMonthExpenseBarGraphData
                                  : thisMonthIncomeBarGraphData,
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
                                      ? thisMonthExpenseIndices.length
                                      : thisMonthIncomeIndices.length);
                              i++)
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  color: (widget.type == "Expense"
                                      ? thisMonthExpenseIndices[i]["color"]
                                      : thisMonthIncomeIndices[i]["color"]),
                                ),
                                SizedBox(width: 4),
                                i == 0
                                    ? Text(
                                        "${(widget.type == "Expense" ? thisMonthExpenseIndices : thisMonthIncomeIndices)[i]["title"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      )
                                    : Text(
                                        "${(widget.type == "Expense" ? thisMonthExpenseIndices : thisMonthIncomeIndices)[i]["title"]}",
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
              ));
  }
}
