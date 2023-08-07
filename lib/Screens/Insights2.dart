import 'package:budget_buddy/Constants/ColorList.dart';
import 'package:budget_buddy/Constants/TryParseDouble.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;
    double totalExpenses =
        tryParseDouble(Provider.of<StateProvider>(context).totalExpenses);
    double totalIncome =
        tryParseDouble(Provider.of<StateProvider>(context).totalIncome);

    double totalTransactions = totalExpenses + totalIncome;
    double incomePercent = (totalIncome / totalTransactions) * 100;
    double expensePercent = (totalExpenses / totalTransactions) * 100;
    bool incomeIsGreater = totalIncome > totalExpenses;

    // Pie chart data entry
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
    // Bar graph data entry
    List<BarChartGroupData> expenseBarGraphData = [];
    List<Map<String, dynamic>> expenseCategoryTypes = [];
    List<Map<String, dynamic>> incomeCategoryTypes = [];
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
      }
      // else {
      //   // For income categories
      //   double incomeCategoryTotalAmount =
      //       tryParseDouble(transaction['amount']);
      //   if (incomeCategoryTypes.isEmpty) {
      //     incomeCategoryTypes.add({
      //       "id": transaction['category'],
      //       "totalAmount": tryParseDouble(transaction['amount'].toString())
      //     });
      //   } else {
      //     bool found = false;
      //     for (var category in incomeCategoryTypes) {
      //       if (transaction['category'] != category['id']) {
      //         found = false;
      //       } else {
      //         found = true;
      //         category['totalAmount'] +=
      //             tryParseDouble(transaction['amount'].toString());
      //       }
      //     }
      //     if (!found) {
      //       incomeCategoryTypes.add(
      //         {
      //           "id": transaction['category'],
      //           "totalAmount": incomeCategoryTotalAmount
      //         },
      //       );
      //     }
      //   }
      // }
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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Income vs Expense",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
              SizedBox(
                height: 10,
              ),
              Text(
                "Expense Breakdown",
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
                    maxY: totalExpenses,
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups: expenseBarGraphData,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Expense vs Income over time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 50),
                          FlSpot(1, 70),
                          FlSpot(2, 40),
                          FlSpot(3, 90),
                          FlSpot(4, 60),
                        ],
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
