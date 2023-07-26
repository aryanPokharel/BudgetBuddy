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

  String _selectedCategory = "Food";
  final List<String> _categories = [
    "Food",
    "Transportation",
    "Entertainment",
    "Shopping",
    "Health",
    "Other"
  ];

  var title = "N/A";
  var amount = "N/A";
  var description = "N/A";

  DateTime? selectedDate;
  dynamic dateToSend;

  // Text edititng controllers
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
    });
  }

  @override
  void initState() {
    super.initState();
    // _selectedCategory = _categories[Random().nextInt(_categories.length)];
  }

  @override
  Widget build(BuildContext context) {
    final List myCategories = Provider.of<StateProvider>(context).categoryList;

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
                      ),
                      Container(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
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
                          "category": _selectedCategory,
                        };
                        saveExpense(newExpense);
                        var snackBar = const SnackBar(
                          content: Text('Expense added'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        clear();
                      } else {
                        var newIncome = {
                          "type": "Income",
                          "title": title,
                          "description": description,
                          "amount": amount,
                          "date": selectedDate,
                          "category": _selectedCategory,
                        };
                        saveIncome(newIncome);
                        var snackBar = const SnackBar(
                          content: Text('Income added'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Icon(Icons.save),
                  ),
                  ElevatedButton(
                    onPressed: clear,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
        duration: const Duration(seconds: 3), // Adjust the duration as needed
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Code to execute when the user taps on the action
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
