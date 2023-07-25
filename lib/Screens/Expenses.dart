import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  void initState() {
    super.initState();
    context.read<StateProvider>();
  }

  List<Map<String, String>> transactions = [
    {"title": "Milk", "price": "100", "description": "Bought 1 litre milk"},
    {"title": "Petrol", "price": "1200", "description": "Filled petrol in car"}
  ];

  addTransaction() {
    setState(
      () {
        transactions.add(
            {"title": "new", "price": "2222", "description": "dummy data"});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> expenseList = Provider.of<StateProvider>(context).expenseList;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // addTransaction();

          Navigator.pushNamed(context, "/addTransaction");
        },
        child: const Icon(Icons.currency_rupee_rounded),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      expenseList[index]['title'].toString(),
                    ),
                  ],
                ),
                subtitle: Text(
                  expenseList[index]['description'].toString(),
                ),
                trailing: Column(
                  children: [
                    Text('Rs. ${expenseList[index]['price']}'),
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
