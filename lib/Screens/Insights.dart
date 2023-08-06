import 'package:budget_buddy/Charts/PieChart.dart';
import 'package:budget_buddy/Constants/SendSnackBar.dart';
import 'package:budget_buddy/Constants/TitleBadge.dart';
import 'package:budget_buddy/Db/DbHelper.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
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
          sendSnackBar(context, "Download Report Feature Coming Soon!");
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
              const TitleBadge(
                title: "Gross Transactions",
                bgColor: Color.fromARGB(255, 193, 175, 15),
              ),
              const SizedBox(
                height: 30,
              ),
              ShowPieChart(
                pieData:
                    (incomePieChartData.isEmpty && expensePieChartData.isEmpty)
                        ? defaultPieData
                        : grossPieChartData,
                pieTitle: "Overall",
              ),
              Divider(color: Colors.grey[400], thickness: 4),
              const SizedBox(
                height: 40,
              ),
              const TitleBadge(title: "Expense Breakdown", bgColor: Colors.red),
              const SizedBox(
                height: 30,
              ),
              ShowPieChart(
                pieData: expensePieChartData.isEmpty
                    ? defaultPieData
                    : expensePieChartData,
                pieTitle: "Expenses",
              ),
              Divider(color: Colors.grey[400], thickness: 4),
              const SizedBox(
                height: 40,
              ),
              const TitleBadge(
                  title: "Income Breakdown", bgColor: Colors.green),
              const SizedBox(
                height: 30,
              ),
              ShowPieChart(
                pieData: incomePieChartData.isEmpty
                    ? defaultPieData
                    : incomePieChartData,
                pieTitle: "Incomes",
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
