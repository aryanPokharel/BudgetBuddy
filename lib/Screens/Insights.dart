import 'package:budget_buddy/Db/DbHelper.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  getCategoryInformation(var categoryId) async {
    Map<String, dynamic>? category = await dbHelper.getCategoryById(categoryId);
    if (category != null) {
      return category;
    } else {
      return null;
    }
  }

  sendSnackBar(dynamic message) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final dbHelper = DatabaseHelper.instance;

  double tryParseDouble(dynamic value) {
    try {
      return double.parse(value.toString());
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;

    List<Map<String, dynamic>> expenseCategoryTypes = [];
    List<Map<String, dynamic>> incomeCategoryTypes = [];

    double totalExpenses =
        tryParseDouble(Provider.of<StateProvider>(context).totalExpenses);
    double totalIncome =
        tryParseDouble(Provider.of<StateProvider>(context).totalIncome);

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

    Map<String, double> expensePieChartData = {};

    for (var expenseCategory in expenseCategoryTypes) {
      expensePieChartData[(expenseCategory['id']).toString()] =
          expenseCategory['totalAmount'];
    }
    Map<String, double> incomePieChartData = {};
    for (var incomeCategory in incomeCategoryTypes) {
      incomePieChartData[(incomeCategory['id']).toString()] =
          incomeCategory['totalAmount'];
    }

    // For gross Transactions
    Map<String, double> grossPieChartData = {
      "Expense": totalExpenses,
      "Income": totalIncome,
    };

    // Default data
    Map<String, double> defaultPieData = {"Empty": 0};

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          sendSnackBar("Download Report Feature Coming Soon!");
        },
        child: const Icon(Icons.download),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 202, 236, 252),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: const Color.fromARGB(255, 190, 190, 6),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Gross Transactions",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              PieChart(
                dataMap:
                    (incomePieChartData.isEmpty || expensePieChartData.isEmpty)
                        ? defaultPieData
                        : grossPieChartData,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 42,
                chartRadius: MediaQuery.of(context).size.width / 1.4,
                colorList:
                    (incomePieChartData.isEmpty || expensePieChartData.isEmpty)
                        ? [Colors.grey]
                        : [
                            Colors.red,
                            Colors.green,
                          ],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 62,
                centerText: "Overall",
                centerTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
                ),
              ),
              Divider(color: Colors.grey[400], thickness: 4),
              const SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Expenses breakdown",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              PieChart(
                dataMap: expensePieChartData.isEmpty
                    ? defaultPieData
                    : expensePieChartData,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 42,
                chartRadius: MediaQuery.of(context).size.width / 1.4,
                colorList: expensePieChartData.isEmpty
                    ? [const Color.fromARGB(255, 177, 150, 150)]
                    : [Colors.red, Colors.blue, Colors.green, Colors.blueGrey],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 62,
                centerText: "EXPENSES",
                centerTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
                ),
              ),
              Divider(color: Colors.grey[400], thickness: 4),
              const SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: const Color.fromARGB(255, 98, 161, 26),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Incomes breakdown",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              PieChart(
                dataMap: incomePieChartData.isEmpty
                    ? defaultPieData
                    : incomePieChartData,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 42,
                chartRadius: MediaQuery.of(context).size.width / 1.4,
                colorList: incomePieChartData.isEmpty
                    ? [const Color.fromARGB(255, 177, 150, 150)]
                    : [Colors.red, Colors.blue, Colors.green, Colors.blueGrey],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 62,
                centerText: "Incomes",
                centerTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  // legendShape: _BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
