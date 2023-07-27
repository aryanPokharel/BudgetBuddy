import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String _transactionType = "Expense";

  var title = "N/A";
  var amount = "N/A";
  var description = "N/A";

  DateTime? selectedDate = DateTime.now();
  dynamic dateToSend;

  var titleController = TextEditingController();
  var amountController = TextEditingController();
  var descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      final DateTime pickedDate =
          DateTime(picked.year, picked.month, picked.day);
      setState(
        () {
          selectedDate = pickedDate;
          dateToSend = "${picked.year}-${picked.month}-${picked.day}";
        },
      );
    }
  }

  saveExpense(dynamic newExpense) {
    context.read<StateProvider>().setExpenseList(newExpense);
    context.read<StateProvider>().setTransactionList(newExpense);
  }

  saveIncome(dynamic newIncome) {
    context.read<StateProvider>().setIncomeList(newIncome);
    context.read<StateProvider>().setTransactionList(newIncome);
  }

  clear() {
    setState(() {
      titleController.clear();
      amountController.clear();
      descriptionController.clear();
      selectedDate = null;
    });
  }

  dynamic selectedCategory;

  @override
  Widget build(BuildContext context) {
    var categoryList = Provider.of<StateProvider>(context).categoryList;

    // var expenseCategories = [];
    // var incomeCategories = [];

    // for (var category in categoryList) {
    //   if (category['type'] == "Expense") {
    //     expenseCategories.add(category.toString());
    //   } else {
    //     incomeCategories.add(category.toString());
    //   }
    // }

    var expenseCategories = categoryList
        .where((category) => category['type'] == 'Expense')
        .toList();

    var incomeCategories =
        categoryList.where((category) => category['type'] == 'Income').toList();

    selectedCategory = _transactionType == 'Expense'
        ? expenseCategories[0]
        : incomeCategories[0];
    sendSnackBar(dynamic message) {
      var snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime dayBeforeYesterday = today.subtract(const Duration(days: 2));
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio(
                    value: "Expense",
                    groupValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value.toString();
                      });
                    },
                  ),
                  const Text("Expense"),
                  const SizedBox(width: 16),
                  Radio(
                    value: "Income",
                    groupValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value.toString();
                      });
                    },
                  ),
                  const Text("Income"),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                onChanged: (val) {
                  setState(() {
                    amount = val;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Amount",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                onChanged: (val) {
                  setState(() {
                    description = val;
                  });
                },
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDate = now;
                      });
                    },
                    child: const Text("Today"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDate = yesterday;
                      });
                    },
                    child: const Text("Yesterday"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 182, 165, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDate = dayBeforeYesterday;
                      });
                    },
                    child: const Text("DayBefore"),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 215, 218, 215),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.calendar_month),
                      Text(
                        selectedDate == null
                            ? 'Please select a date'
                            : "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<dynamic>(
                value: _transactionType == "Expense"
                    ? expenseCategories[0]
                    : incomeCategories[0],
                items: _transactionType == "Expense"
                    ? expenseCategories.map((dynamic category) {
                        final Map<String, dynamic> categoryData =
                            category as Map<String, dynamic>;
                        return DropdownMenuItem<dynamic>(
                          value: category,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(IconData(categoryData['icon'],
                                  fontFamily: 'MaterialIcons')),
                              Text(categoryData['title']),
                            ],
                          ),
                        );
                      }).toList()
                    : incomeCategories.map((dynamic category) {
                        final Map<String, dynamic> categoryData =
                            category as Map<String, dynamic>;
                        return DropdownMenuItem<dynamic>(
                          value: category,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                IconData(categoryData['icon'],
                                    fontFamily: 'MaterialIcons'),
                              ),
                              Text(
                                categoryData['title'],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Select category",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_transactionType == "Expense") {
                        var newExpense = {
                          "type": "Expense",
                          "title": title,
                          "description": description,
                          "amount": amount,
                          "date": selectedDate,
                          "category": selectedCategory,
                        };
                        saveExpense(newExpense);
                        sendSnackBar("Expense Added");

                        clear();
                      } else {
                        var newIncome = {
                          "type": "Income",
                          "title": title,
                          "description": description,
                          "amount": amount,
                          "date": selectedDate,
                          "category": selectedCategory,
                        };
                        saveIncome(newIncome);
                        sendSnackBar("Income Added");
                        clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.save),
                  ),
                  ElevatedButton(
                    onPressed: clear,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.delete),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This is a simple Snackbar.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
