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
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                              leading: transactionList[index]['type'] ==
                                      "Expense"
                                  ? const Icon(Icons.coffee, color: Colors.red)
                                  : const Icon(Icons.music_video_rounded,
                                      color: Colors.green),
                              title: Text(
                                transactionList[index]['title'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                transactionList[index]['description']
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              trailing: Text(
                                'Rs. ${transactionList[index]['amount']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              onLongPress: () => {
                                toDelete = index,
                                _toggleOverlay(),
                              },
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
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      deleteItem();
                                      _toggleOverlay();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
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
