import 'package:budget_buddy/Constants/DancingDoge.dart';
import 'package:budget_buddy/Constants/GetCategoryData.dart';
import 'package:budget_buddy/Constants/TryParseDouble.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlPieGraph extends StatefulWidget {
  const FlPieGraph({super.key});

  @override
  State<FlPieGraph> createState() => _FlPieGraphState();
}

class _FlPieGraphState extends State<FlPieGraph> {
  List<String> expenseCategoryTitles = [];
  getExCatTitle(numberOfCategory) async {
    for (int i = 1; i < numberOfCategory; i++) {
      var category = await dbHelper.getCategoryById(i);
      if (category!['type'] == "Expense") {
        expenseCategoryTitles.add(category['title']);
      }
    }
  }

  List<String> incomeCategoryTitles = [];
  getInCatTitle(numberOfCategory) async {
    for (int i = 1; i < numberOfCategory; i++) {
      var category = await dbHelper.getCategoryById(i);
      if (category!['type'] == "Income") {
        incomeCategoryTitles.add(category['title']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses =
        tryParseDouble(Provider.of<StateProvider>(context).totalExpenses);
    double totalIncome =
        tryParseDouble(Provider.of<StateProvider>(context).totalIncome);

    double totalTransactions = totalExpenses + totalIncome;
    double incomePercent = (totalIncome / totalTransactions) * 100;
    double expensePercent = (totalExpenses / totalTransactions) * 100;
    bool incomeIsGreater = totalIncome > totalExpenses;

    List<PieChartSectionData> pieChartData = [];
    for (int i = 0; i < 2; i++) {
      pieChartData.add(
        PieChartSectionData(
          value: i == 1 ? totalIncome : totalExpenses,
          color: i == 1 ? Colors.green : Colors.red,
          title: i == 1 ? "Income" : "Expense",
          radius: i == 1
              ? (incomeIsGreater ? 70 : 60)
              : (incomeIsGreater ? 60 : 70),
          titleStyle: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    List<Map<String, dynamic>> data = [
      {
        "value": incomePercent.toStringAsFixed(
            totalExpenses.truncateToDouble() == totalExpenses ? 0 : 2),
        "color": Colors.green,
        "title": "Income"
      },
      {
        "value": expensePercent.toStringAsFixed(
            totalExpenses.truncateToDouble() == totalExpenses ? 0 : 2),
        "color": Colors.red,
        "title": "Expense"
      },
    ];
    return (totalExpenses == 0 && totalIncome == 0)
        ? SizedBox(height: 300, child: DancingDoge())
        : Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: pieChartData,
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
                                    "${data[i]["title"]}  : ${data[i]["value"]}%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                : Text(
                                    "${data[i]["title"]} : ${data[i]["value"]}%",
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
