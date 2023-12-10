import 'package:budget_buddy/Constants/Constants.dart';
import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlPieGraph2 extends StatefulWidget {
  final transactionType;
  const FlPieGraph2({this.transactionType, super.key});

  @override
  State<FlPieGraph2> createState() => _FlPieGraph2State();
}

class _FlPieGraph2State extends State<FlPieGraph2> {
  late bool showMonthlyData;

  @override
  Widget build(BuildContext context) {
    showMonthlyData = Provider.of<StateProvider>(context).showMonthlyData;
    List<dynamic> transactionList = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthTransactions
        : Provider.of<StateProvider>(context).transactionList;

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

    List<PieChartSectionData> expensePieChartData = [];
    List<PieChartSectionData> incomePieChartData = [];
    if (widget.transactionType == "Expense") {
      for (int i = 0; i < expenseCategoryTypes.length; i++) {
        if (expenseCategoryTypes.length > 0) {
          expensePieChartData.add(
            PieChartSectionData(
              value: expenseCategoryTypes[i]['totalAmount'],
              color: appThemeColors[i],
              showTitle: false,
            ),
          );
        }
      }
    } else {
      for (int i = 0; i < incomeCategoryTypes.length; i++) {
        if (incomeCategoryTypes.length > 0)
          incomePieChartData.add(
            PieChartSectionData(
              value: incomeCategoryTypes[i]['totalAmount'],
              color: appThemeColors[i],
              showTitle: false,
            ),
          );
      }
    }
    List<Map<String, dynamic>> expenseData = [];
    double totalExpenses = 0;

    for (int j = 0; j < expenseCategoryTypes.length; j++) {
      expenseData.add({
        "value": expenseCategoryTypes[j]['totalAmount'],
        "color": appThemeColors[j],
        "title": expenseCateogoryTypesTitles.length > 0
            ? expenseCateogoryTypesTitles[j]
            : "No Data"
      });
      totalExpenses += (expenseCategoryTypes[j]['totalAmount']) as double;
    }

    List<Map<String, dynamic>> incomeData = [];
    double totalIncome = 0;
    for (int k = 0; k < incomeCategoryTypes.length; k++) {
      incomeData.add({
        "value": incomeCategoryTypes[k]['totalAmount'],
        "color": appThemeColors[k],
        "title": incomeCateogoryTypesTitles.length > 0
            ? incomeCateogoryTypesTitles[k]
            : "No Data"
      });
      totalIncome += (incomeCategoryTypes[k]['totalAmount']) as double;
    }

    return (widget.transactionType == "Expense" && totalExpenses == 0) ||
            (widget.transactionType == "Income" && totalIncome == 0)
        ? SizedBox(
            height: 300,
            child: EmptyListWidget(),
          )
        : Column(
            children: [
              Text(
                "${widget.transactionType} Breakdown",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: widget.transactionType == "Expense"
                        ? expensePieChartData
                        : incomePieChartData,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.transactionType == "Expense"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < expenseData.length; i++)
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: expenseData[i]["color"],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "${expenseData[i]["title"]}  : ${((expenseData[i]["value"] / totalExpenses) * 100).toStringAsFixed(totalExpenses.truncateToDouble() == totalExpenses ? 0 : 2)}%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < incomeData.length; i++)
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: incomeData[i]["color"],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "${incomeData[i]["title"]}  : ${((incomeData[i]["value"] / totalIncome) * 100).toStringAsFixed(totalIncome.truncateToDouble() == totalIncome ? 0 : 2)}%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
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
