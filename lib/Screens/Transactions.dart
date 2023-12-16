import 'package:budget_buddy/Constants/Constants.dart';
import 'package:budget_buddy/Constants/DateName.dart';
import 'package:budget_buddy/Constants/FormatDate.dart';
import 'package:budget_buddy/Constants/GetCategoryData.dart';
import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:budget_buddy/AdWidgets/MyAdWidget.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Constants/FormatTimeOfDay.dart';

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

  late bool showMonthlyData;

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<StateProvider>(context).currency;
    String currencySymbol = currencyMap[currency]!;

    bool darkModeEnabled = Provider.of<StateProvider>(context).darkTheme;
    var appTheme = Provider.of<StateProvider>(context).appTheme;

    showMonthlyData = Provider.of<StateProvider>(context).showMonthlyData;
    List<dynamic> transactionList = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthTransactions
        : Provider.of<StateProvider>(context).transactionList;
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
        backgroundColor: darkModeEnabled ? appTheme[700] : appTheme,
        foregroundColor: Colors.white70,
        child: Text(
          currencySymbol,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: transactionList.isEmpty
          ? Container(
              color: darkModeEnabled
                  ? Color.fromARGB(255, 112, 112, 112)
                  : Color.fromARGB(255, 222, 222, 222),
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    EmptyListWidget(),
                    // MyAdWidget(),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: darkModeEnabled
                      ? Color.fromARGB(255, 112, 112, 112)
                      : Color.fromARGB(255, 222, 222, 222),
                ),
                ListView.builder(
                  itemCount: groupedTransactions.length + 1,
                  itemBuilder: ((context, index) {
                    if (index == groupedTransactions.length) {
                      return MyAdWidget();
                    } else {
                      var date = groupedTransactions.keys.elementAt(index);
                      var transactions = groupedTransactions[date];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: darkModeEnabled
                                ? Color.fromARGB(255, 112, 112, 112)
                                : Color.fromARGB(255, 222, 222, 222),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text(
                                checkTodayYesterday(
                                  date.toString(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: darkModeEnabled
                                      ? Colors.white70
                                      : Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                          ...transactions!.map(
                            (transaction) {
                              return FutureBuilder(
                                future:
                                    getCategoryIcon(transaction['category']),
                                builder: (context, snapshot) {
                                  int iconCodePoint = snapshot.hasData
                                      ? int.tryParse(
                                              snapshot.data.toString()) ??
                                          Icons.error_outline.codePoint
                                      : Icons.error_outline.codePoint;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: transaction['type'] == 'Expense'
                                            ? Colors.red[100]
                                            : Colors.green[100],
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
                                      child: Slidable(
                                        key: ValueKey(transaction['id']),
                                        startActionPane: ActionPane(
                                          motion: StretchMotion(),
                                          dismissible:
                                              DismissiblePane(onDismissed: () {
                                            context
                                                .read<StateProvider>()
                                                .deleteTransaction(
                                                    transaction['id']);
                                          }),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) async {
                                                toDelete = transaction['id'];
                                                _toggleOverlay();
                                              },
                                              backgroundColor:
                                                  Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        endActionPane: ActionPane(
                                          motion: StretchMotion(),
                                          children: [
                                            SlidableAction(
                                              flex: 2,
                                              onPressed: (context) async {
                                                await context
                                                    .read<StateProvider>()
                                                    .setTransactionToUpdate(
                                                        transaction['id']);
                                                Navigator.pushNamed(context,
                                                    '/updateTransaction');
                                              },
                                              backgroundColor:
                                                  Color(0xFF7BC043),
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              label: 'Edit',
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ListTile(
                                              tileColor: Colors.white70,
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    transaction['type'] ==
                                                            'Expense'
                                                        ? Colors.red[100]
                                                        : Colors.green[100],
                                                child: Icon(
                                                  IconData(
                                                    iconCodePoint,
                                                    fontFamily: 'MaterialIcons',
                                                  ),
                                                  color: transaction['type'] ==
                                                          'Expense'
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
                                                  color: Colors.black,
                                                ),
                                              ),
                                              subtitle:
                                                  transaction['remarks'] !=
                                                              null &&
                                                          transaction['remarks']
                                                              .toString()
                                                              .isNotEmpty
                                                      ? Text(
                                                          transaction['remarks']
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    '$currencySymbol ${transaction['amount'].toString()}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          transaction['type'] ==
                                                                  'Expense'
                                                              ? Colors.red
                                                              : Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                await context
                                                    .read<StateProvider>()
                                                    .setTransactionToUpdate(
                                                        transaction['id']);
                                                Navigator.pushNamed(context,
                                                    '/updateTransaction');
                                              },
                                              onLongPress: () {
                                                toDelete = transaction['id'];
                                                _toggleOverlay();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ).toList(),
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
