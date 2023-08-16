import 'package:budget_buddy/Charts/BarGraph.dart';
import 'package:budget_buddy/Charts/LineGraph.dart';
import 'package:budget_buddy/Charts/PieGraph.dart';
import 'package:flutter/material.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  String _transactionType = "Expense";
  String graphType = "Pie";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 222, 222, 222),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRadioOption("Gross", "Pie"),
                  const SizedBox(width: 16),
                  _buildRadioOption("Gross", "Line"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Income vs Expense",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              graphType == "Pie" ? FlPieGraph() : FlLineGraph(),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRadioOption("Individual", "Expense"),
                  const SizedBox(width: 16),
                  _buildRadioOption("Individual", "Income"),
                ],
              ),
              const SizedBox(height: 16),
              _transactionType == "Expense"
                  ? FlBarGraph(
                      type: "Expense",
                    )
                  : FlBarGraph(
                      type: "Income",
                    ),
              Divider(
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String insightType, String option) {
    return InkWell(
      onTap: () {
        setState(() {
          insightType == "Individual"
              ? _transactionType = option
              : graphType = option;
          ;
        });
      },
      child: insightType == "Individual"
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _transactionType == option
                    ? Colors.blue
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _transactionType == option ? Colors.blue : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color:
                      _transactionType == option ? Colors.white : Colors.black,
                  fontWeight: _transactionType == option
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: graphType == option ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: graphType == option ? Colors.blue : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: graphType == option ? Colors.white : Colors.black,
                  fontWeight:
                      graphType == option ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
    );
  }
}
