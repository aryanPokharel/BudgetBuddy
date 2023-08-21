import 'package:budget_buddy/Charts/BarGraph.dart';
import 'package:budget_buddy/Charts/LineGraph.dart';
import 'package:budget_buddy/Charts/PieGraph.dart';
import 'package:budget_buddy/Charts/PieGraph2.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  String _barTransactionType = "Expense";
  String _pieTransactionType = "Expense";
  String grossGraphType = "Pie";

  String individualGraphType = "Pie";
  @override
  void initState() {
    super.initState();
  }

  late bool showMonthlyData;

  @override
  Widget build(BuildContext context) {
    showMonthlyData = Provider.of<StateProvider>(context).showMonthlyData;

    List<dynamic> expenseCategoryTypes = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthExpenseCategoryTypes
        : Provider.of<StateProvider>(context).expenseCategoryTypes;
    List<dynamic> incomeCategoryTypes = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthIncomeCategoryTypes
        : Provider.of<StateProvider>(context).incomeCategoryTypes;

    bool noData =
        (expenseCategoryTypes.length == 0 && incomeCategoryTypes.length == 0);
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
                  _buildRadioOption("Gross", "Pie", "Pie"),
                  const SizedBox(width: 16),
                  _buildRadioOption("Gross", "Line", "Line"),
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
              grossGraphType == "Pie"
                  ? FlPieGraph(
                      insightType: showMonthlyData ? "Monthly" : "Overall")
                  : FlLineGraph(
                      insightType: showMonthlyData ? "Monthly" : "Overall"),
              Divider(
                thickness: 2,
              ),
              noData
                  ? Text("")
                  : Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRadioOption("Individual", "Bar", "Expense"),
                              const SizedBox(width: 16),
                              _buildRadioOption("Individual", "Bar", "Income"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _barTransactionType == "Expense"
                              ? FlBarGraph(
                                  type: "Expense",
                                )
                              : FlBarGraph(
                                  type: "Income",
                                ),
                          Divider(
                            thickness: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRadioOption("Individual", "Pie", "Expense"),
                              const SizedBox(width: 16),
                              _buildRadioOption("Individual", "Pie", "Income"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _pieTransactionType == "Expense"
                              ? FlPieGraph2(
                                  transactionType: "Expense",
                                )
                              : FlPieGraph2(
                                  transactionType: "Income",
                                ),
                          Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(
      String insightType, String graphType, String option) {
    return InkWell(
      onTap: () {
        setState(() {
          insightType == "Individual"
              ? graphType == "Bar"
                  ? _barTransactionType = option
                  : _pieTransactionType = option
              : grossGraphType = option;
          ;
        });
      },
      child: insightType == "Individual"
          ? graphType == "Bar"
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _barTransactionType == option
                        ? Colors.blue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _barTransactionType == option
                          ? Colors.blue
                          : Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: _barTransactionType == option
                          ? Colors.white
                          : Colors.black,
                      fontWeight: _barTransactionType == option
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _pieTransactionType == option
                        ? Colors.blue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _pieTransactionType == option
                          ? Colors.blue
                          : Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: _pieTransactionType == option
                          ? Colors.white
                          : Colors.black,
                      fontWeight: _pieTransactionType == option
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    grossGraphType == option ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: grossGraphType == option ? Colors.blue : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: grossGraphType == option ? Colors.white : Colors.black,
                  fontWeight: grossGraphType == option
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
    );
  }
}
