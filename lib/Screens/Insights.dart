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

  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;

    List categoryTypes = [];

    for (var transaction in transactionList) {
      double categoryTotalAmount = double.parse(transaction['amount']);

      if (categoryTypes.isEmpty) {
        categoryTypes.add({
          "id": transaction['category'],
          "totalAmount": double.parse(transaction['amount'])
        });
      } else {
        bool found = false;
        for (var category in categoryTypes) {
          if (transaction['category'] != category['id']) {
            found = false;
          } else {
            found = true;
            category['totalAmount'] += double.parse(transaction['amount']);
          }
        }
        if (!found) {
          categoryTypes.add(
            {"id": transaction['category'], "totalAmount": categoryTotalAmount},
          );
        }
      }
    }

    Map<String, double> pieChartData = {};

    for (var category in categoryTypes) {
      pieChartData[(category['id']).toString()] = category['totalAmount'];
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          sendSnackBar("Insights page being built!");
        },
        child: const Icon(Icons.calculate_rounded),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Expenditure breakdown"),
          PieChart(
            dataMap: pieChartData,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 42,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            colorList: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.blueGrey
            ],
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 62,
            // centerText: "EXPENSES",
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
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
        ],
      ),
    );
  }
}
