import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Map<String, String>> transactions = [
    {"title": "Milk", "price": "100", "description": "Bought 1 litre milk"},
    {"title": "Petrol", "price": "1200", "description": "Filled petrol in car"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Row(children: [
                  Text(
                    transactions[index]['title'].toString(),
                  ),
                ]),
                subtitle: Text(transactions[index]['description'].toString()),
                trailing: Column(
                  children: [
                    Text('Rs. ${transactions[index]['price']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
