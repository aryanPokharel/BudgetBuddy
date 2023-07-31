import 'package:budget_buddy/Db/DbHelper.dart';
import 'package:flutter/material.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  sendSnackBar(dynamic message) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          sendSnackBar("Insights page being built!");
        },
        child: const Icon(Icons.calculate_rounded),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 60,
            ),
            Text("Insights page being built"),
          ],
        ),
      ),
    );
  }
}
