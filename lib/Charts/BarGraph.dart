import 'package:budget_buddy/Constants/Constants.dart';
import 'package:budget_buddy/Constants/LooksEmpty.dart';
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
  late bool showMonthlyData;
  @override
  void initState() {
    super.initState();
    // context.read<StateProvider>().fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    showMonthlyData = Provider.of<StateProvider>(context).showMonthlyData;
    List<dynamic> transactionList = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthTransactions
        : Provider.of<StateProvider>(context).transactionList;

    List<BarChartGroupData> expenseBarGraphData = [];
    List<BarChartGroupData> incomeBarGraphData = [];

    List<dynamic> expenseCategoryTypes = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthExpenseCategoryTypes
        : Provider.of<StateProvider>(context).expenseCategoryTypes;
    List<dynamic> incomeCategoryTypes = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthIncomeCategoryTypes
        : Provider.of<StateProvider>(context).incomeCategoryTypes;

    var expenseCateogoryTypesTitles = showMonthlyData
        ? Provider.of<StateProvider>(context)
            .thisMonthExpenseCategoryTypesTitles
        : Provider.of<StateProvider>(context).expenseCategoryTypesTitles;
    var incomeCateogoryTypesTitles = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthIncomeCategoryTypesTitles
        : Provider.of<StateProvider>(context).incomeCategoryTypesTitles;
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
          "title": expenseCateogoryTypesTitles.length > 0
              ? expenseCateogoryTypesTitles[l]
              : "notFound"
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
          "title": incomeCateogoryTypesTitles.length > 0
              ? incomeCateogoryTypesTitles[m]
              : "notFound"
        },
      );
      m++;
    }

    return (transactionList.length < 1)
        ? SizedBox(
            height: 300,
            child: EmptyListWidget(),
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
                      child: EmptyListWidget(),
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
