import 'package:budget_buddy/Constants/LooksEmpty.dart';
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

  bool _showOverlay = false;

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  var toDelete;
  deleteItem() {
    context.read<StateProvider>().deleteTransaction(toDelete);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;
    // List<dynamic> expenseList = Provider.of<StateProvider>(context).expenseList;
    // List<dynamic> incomeList = Provider.of<StateProvider>(context).incomeList;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addTransaction");
        },
        child: const Icon(Icons.currency_rupee_rounded),
      ),
      body: transactionList.isEmpty
          ? const Center(
              child: EmptyListWidget(),
            )
          : Stack(
              children: [
                Center(
                  child: ListView.builder(
                    itemCount: transactionList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: const Color.fromARGB(255, 231, 229, 229),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 2,
                                  color: transactionList[index]['type'] ==
                                          'Expense'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                            child: ListTile(
                              leading:
                                  transactionList[index]['category'] == "Food"
                                      ? const Icon(Icons.coffee)
                                      : const Icon(Icons.music_video_rounded),
                              title: Row(
                                children: [
                                  Text(
                                    transactionList[index]['title'].toString(),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                transactionList[index]['description']
                                    .toString(),
                              ),
                              trailing: Text(
                                  'Rs. ${transactionList[index]['amount']}'),
                              onLongPress: () =>
                                  {toDelete = index, _toggleOverlay()},
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_showOverlay)
                  GestureDetector(
                    onTap: _toggleOverlay,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Card(
                          color: const Color.fromARGB(255, 212, 216, 219),
                          elevation: 4,
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Deleting Item!',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              const Text(
                                'Are you sure?',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      deleteItem();
                                      _toggleOverlay();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      _toggleOverlay();
                                    },
                                    child: const Text('No'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
