import 'package:budget_buddy/Constants/DateConverter.dart';
import 'package:budget_buddy/Constants/FormatDate.dart';
import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:budget_buddy/Constants/TimeConverter.dart';
import 'package:budget_buddy/Db/DbHelper.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final dbHelper = DatabaseHelper.instance;

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
  void initState() {
    super.initState();
    context.read<StateProvider>().getTransactionsFromDb();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).transactionList;

    if (transactionList.isNotEmpty) {
      // working on grouping the transaction based on the day of the month

// Step 1 : sort the transactions on the basis of the date.
//Get the latest transaction at the top of the list
      transactionList.sort(
        (a, b) => b['dateTime'].compareTo(
          a['dateTime'],
        ),
      );

      //  Step 2 : create lists associated to individual days of the month
      // and insert each transaction on the basis of the common days.

      var referenceDate = DateTime.parse(transactionList[0]['dateTime']);
      Map<String, List<Map<String, dynamic>>> groupedTransactions = {
        formatDate(referenceDate): [transactionList[0]]
      };

      for (var i = 1; i < transactionList.length; i++) {
        var transactionDate = DateTime.parse(transactionList[i]['dateTime']);
        var transactionDateFormatted = formatDate(transactionDate);

        if (transactionDateFormatted == formatDate(referenceDate)) {
          // Add the transaction to the existing list for this date
          groupedTransactions[transactionDateFormatted]!
              .add(transactionList[i]);
        } else {
          // Create a new list for the new date and add the transaction to it
          groupedTransactions[transactionDateFormatted] = [transactionList[i]];
          referenceDate = transactionDate;
        }
      }

      // Printing the grouped transactions
      groupedTransactions.forEach((date, transactions) {
        print('Transactions for $date:');
        for (var transaction in transactions) {
          print(transaction);
        }
      });
    }

    dynamic getCategoryData(dynamic categoryId) async {
      Map<String, dynamic>? categoryData =
          await dbHelper.getCategoryById(categoryId);
      String iconData = categoryData!['icon'];
      return iconData;
    }

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
                ListView.builder(
                  itemCount: transactionList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == transactionList.length) {
                      // Show an empty card after the last item in the list
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: SizedBox(
                            height: 70, // Adjust the height as needed
                          ),
                        ),
                      );
                    }
                    return FutureBuilder(
                        future:
                            getCategoryData(transactionList[index]['category']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While the future is still resolving, show a loading indicator or a placeholder widget
                            return const CircularProgressIndicator(); // Replace with any loading widget you prefer
                          } else if (snapshot.hasError) {
                            // If an error occurred during the future execution, handle it here
                            return Text('Error: ${snapshot.error}');
                          }

                          var iconCodePoint = snapshot.data;
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              color: const Color.fromARGB(255, 230, 232, 230),
                              elevation: 4,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 4,
                                      color: transactionList[index]['type'] ==
                                              'Expense'
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: transactionList[index]
                                                ['type'] ==
                                            'Expense'
                                        ? Colors.red[100]
                                        : Colors.green[100],
                                    child: Icon(
                                      IconData(
                                        int.parse(
                                          iconCodePoint.toString(),
                                        ),
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: transactionList[index]['type'] ==
                                              'Expense'
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  title: Text(
                                    transactionList[index]['title'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      if (transactionList[index]['remarks'] !=
                                          null)
                                        Text(
                                          transactionList[index]['remarks']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      if (transactionList[index]['dateTime'] !=
                                          null)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.calendar_month),
                                                Text(
                                                  formatDateToWordBased(
                                                      transactionList[index]
                                                          ['dateTime']),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 16,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  convertTime(
                                                      transactionList[index]
                                                              ['dateTime']
                                                          .toString()),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  trailing: Text(
                                    'Rs. ${transactionList[index]['amount']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: transactionList[index]['type'] ==
                                              'Expense'
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  onTap: () async {
                                    Map<String, dynamic>? categoryData =
                                        await dbHelper.getCategoryById(
                                            transactionList[index]['category']);
                                    if (categoryData != null) {
                                      print(categoryData[
                                          'icon']); // Print the category data
                                    }
                                  },
                                  onLongPress: () {
                                    toDelete = transactionList[index]['id'];
                                    _toggleOverlay();
                                  },
                                ),
                              ),
                            ),
                          );
                        });
                  },
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
