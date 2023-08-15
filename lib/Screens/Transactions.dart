import 'package:budget_buddy/Constants/DateName.dart';
import 'package:budget_buddy/Constants/FormatDate.dart';
import 'package:budget_buddy/Constants/FormatTimeOfDay.dart';
import 'package:budget_buddy/Constants/GetCategoryData.dart';
import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
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

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<StateProvider>().fetchAllData();
  //   Provider.of<StateProvider>(context).dataLoaded;
  // }

  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionList =
        Provider.of<StateProvider>(context).thisMonthTransactions;
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    if (transactionList.isNotEmpty) {
      transactionList.sort(
        (a, b) => b['dateTime'].compareTo(
          a['dateTime'],
        ),
      );
      var referenceDate = DateTime.parse(transactionList[0]['dateTime']);
      groupedTransactions = {
        formatDate(referenceDate): [transactionList[0]]
      };

      for (var i = 1; i < transactionList.length; i++) {
        var transactionDate = DateTime.parse(transactionList[i]['dateTime']);
        var transactionDateFormatted = formatDate(transactionDate);

        if (transactionDateFormatted == formatDate(referenceDate)) {
          groupedTransactions[transactionDateFormatted]!
              .add(transactionList[i]);
        } else {
          groupedTransactions[transactionDateFormatted] = [transactionList[i]];
          referenceDate = transactionDate;
        }
      }
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "addTransaction",
        onPressed: () {
          Navigator.pushNamed(context, "/addTransaction");
        },
        child: const Icon(Icons.currency_rupee_rounded),
      ),
      body: transactionList.isEmpty
          ? Container(
              color: Color.fromARGB(255, 203, 203, 203),
              child: Center(
                child: EmptyListWidget(),
              ),
            )
          : Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromARGB(255, 222, 222, 222),
                ),
                ListView.builder(
                  itemCount: groupedTransactions.length + 1,
                  itemBuilder: ((context, index) {
                    if (index == groupedTransactions.length) {
                      return const SizedBox(
                        height: 80,
                      );
                    } else {
                      var date = groupedTransactions.keys.elementAt(index);
                      var transactions = groupedTransactions[date];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 223, 225, 225),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text(
                                checkTodayYesterday(
                                  date.toString(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                          ...transactions!.map((transaction) {
                            return FutureBuilder(
                              future: getCategoryIcon(transaction['category']),
                              builder: (context, snapshot) {
                                int iconCodePoint = snapshot.hasData
                                    ? int.tryParse(snapshot.data.toString()) ??
                                        Icons.error_outline.codePoint
                                    : Icons.error_outline.codePoint;

                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: transaction['type'] == 'Expense'
                                          ? Color.fromARGB(255, 255, 242, 241)
                                          : Color.fromARGB(255, 245, 255, 234),
                                      border: Border(
                                        left: BorderSide(
                                          width: 4,
                                          color:
                                              transaction['type'] == 'Expense'
                                                  ? Colors.red
                                                  : Colors.green,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      tileColor: Colors.white,
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            transaction['type'] == 'Expense'
                                                ? Colors.red[100]
                                                : Colors.green[100],
                                        child: Icon(
                                          IconData(
                                            iconCodePoint,
                                            fontFamily: 'MaterialIcons',
                                          ),
                                          color:
                                              transaction['type'] == 'Expense'
                                                  ? const Color.fromARGB(
                                                      255, 243, 97, 87)
                                                  : Color.fromARGB(
                                                      255, 113, 189, 115),
                                        ),
                                      ),
                                      title: Text(
                                        transaction['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: transaction['remarks'] !=
                                                  null &&
                                              transaction['remarks']
                                                  .toString()
                                                  .isNotEmpty
                                          ? Text(
                                              transaction['remarks'].toString(),
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            )
                                          : null,
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            formatTimeOfDay(
                                                transaction['time']),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Rs.${transaction['amount'].toString()}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: transaction['type'] ==
                                                      'Expense'
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        var test = await context
                                            .read<StateProvider>()
                                            .setTransactionToUpdate(
                                                transaction['id']);
                                        Navigator.pushNamed(
                                            context, '/updateTransaction');
                                      },
                                      onLongPress: () {
                                        toDelete = transaction['id'];
                                        _toggleOverlay();
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ],
                      );
                    }
                  }),
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
