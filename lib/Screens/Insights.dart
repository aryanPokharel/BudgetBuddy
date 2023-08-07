import 'package:budget_buddy/Charts/BarGraph.dart';
import 'package:budget_buddy/Charts/LineGraph.dart';
import 'package:budget_buddy/Charts/PieGraph.dart';
import 'package:flutter/material.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlPieGraph(),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 60,
              ),
              FlBarGraph(
                type: "Expense",
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              FlBarGraph(
                type: "Income",
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              FlLineGraph(),
            ],
          ),
        ),
      ),
    );
  }
}
