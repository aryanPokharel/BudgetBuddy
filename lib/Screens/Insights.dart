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
    bool found = false;

    for (var transaction in transactionList) {
      double categoryTotalAmount = double.parse(transaction['amount']);

      for (var category in categoryTypes) {
        if (transaction['category'] == category) {
          found = true;
          categoryTotalAmount += double.parse(transaction['amount']);
          break;
        }
      }

      if (!found) {
        categoryTypes.add(
          {"id": transaction['category'], "totalAmount": categoryTotalAmount},
        );
      }
    }

    Map<String, double> pieChartData = {};

    for (var category in categoryTypes) {
      pieChartData[category['id'].toString()] = category['totalAmount'];
    }
    // Map<String, double> pieChartData = {
    //   "Flutter": 5,
    //   "React": 3,
    //   "Xamarin": 2,
    //   "Ionic": 2,
    // };
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          sendSnackBar("Insights page being built!");
        },
        child: const Icon(Icons.calculate_rounded),
      ),
      body: Center(
        child: PieChart(
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
            legendPosition: LegendPosition.right,
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
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ),
      ),
    );
  }
}
