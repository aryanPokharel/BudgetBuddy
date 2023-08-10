import 'package:budget_buddy/Constants/FormatTimeOfDay.dart';
import 'package:budget_buddy/Constants/SendSnackBar.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateTransaction extends StatefulWidget {
  const UpdateTransaction({super.key});

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  late String _transactionType;

  late DateTime selectedDate;
  dynamic dateToSend;

  var titleController = TextEditingController();
  var amountController = TextEditingController();
  var remarksController = TextEditingController();

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

  updateExpense(dynamic updatedExpense) {
    context.read<StateProvider>().updateTransaction(updatedExpense);
  }

  updateIncome(dynamic updatedIncome) {
    context.read<StateProvider>().updateTransaction(updatedIncome);
  }

  clear() {
    setState(() {
      titleController.clear();
      amountController.clear();
      remarksController.clear();
    });
  }

  dynamic selectedCategory;
  late TimeOfDay selectedTime;
  @override
  void initState() {
    super.initState();
    dynamic transactionToUpdate =
        Provider.of<StateProvider>(context, listen: false).transactionToUpdate;
    _transactionType = transactionToUpdate['type'];
    titleController.text = transactionToUpdate['title'];
    amountController.text = transactionToUpdate['amount'].toString();
    remarksController.text = transactionToUpdate['remarks'] != null &&
            transactionToUpdate['remarks'].toString().isNotEmpty
        ? transactionToUpdate['remarks'].toString()
        : "";

    selectedDate = DateTime.parse(transactionToUpdate['dateTime']);
    selectedTime = parseStringToTimeOfDay(transactionToUpdate['time']);
  }

  @override
  Widget build(BuildContext context) {
    var categoryList = Provider.of<StateProvider>(context).categoryList;
    dynamic transactionToUpdate =
        Provider.of<StateProvider>(context, listen: false).transactionToUpdate;
    var expenseCategories = categoryList
        .where((category) => category['type'] == 'Expense')
        .toList();

    var incomeCategories =
        categoryList.where((category) => category['type'] == 'Income').toList();

    setState(() {
      selectedCategory = _transactionType == 'Expense'
          ? expenseCategories.firstWhere(
              (element) => element['id'] == transactionToUpdate['category'],
              orElse: () => null,
            )
          : incomeCategories.firstWhere(
              (element) => element['id'] == transactionToUpdate['category'],
              orElse: () => null,
            );
    });

    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime dayBeforeYesterday = now.subtract(const Duration(days: 2));

    final formKey = GlobalKey<FormState>();

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null && pickedTime != selectedTime) {
        setState(() {
          selectedTime = pickedTime;
        });
      }
    }

    bool typeChanged = false;

    return Scaffold(
      backgroundColor: _transactionType == "Expense"
          ? const Color.fromARGB(255, 196, 214, 222)
          : const Color.fromARGB(255, 210, 219, 200),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRadioOption("Expense"),
                    const SizedBox(width: 16),
                    _buildRadioOption("Income"),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Give a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Amount",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: remarksController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: "Remarks",
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDate = now;
                          selectedTime = TimeOfDay.now();
                        });
                      },
                      child: const Text(
                        "Today",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDate = yesterday;
                          selectedTime = TimeOfDay.now();
                        });
                      },
                      child: const Text(
                        "Yesterday",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 182, 165, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDate = dayBeforeYesterday;
                          selectedTime = TimeOfDay.now();
                        });
                      },
                      child: const Text(
                        "DayBefore",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 14, 100, 139),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.alarm,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedTime.format(context),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<dynamic>(
                  value: selectedCategory,
                  items: _transactionType == "Expense"
                      ? expenseCategories.map((dynamic category) {
                          final Map<String, dynamic> categoryData =
                              category as Map<String, dynamic>;
                          return DropdownMenuItem<dynamic>(
                            value: category,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  IconData(
                                      int.parse(
                                        categoryData['icon'],
                                      ),
                                      fontFamily: 'MaterialIcons'),
                                ),
                                const SizedBox(
                                  width: 110,
                                ),
                                Text(
                                  categoryData['title'],
                                ),
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
                                  IconData(
                                      int.parse(
                                        categoryData['icon'],
                                      ),
                                      fontFamily: 'MaterialIcons'),
                                ),
                                const SizedBox(
                                  width: 110,
                                ),
                                Text(
                                  categoryData['title'],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  onChanged: (value) {
                    typeChanged = true;
                    selectedCategory = value['id'];
                  },
                  decoration: const InputDecoration(
                    hintText: "Select category",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select a category';
                    }
                    return null;
                  },
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
                          var updatedExpense = {
                            "_id": transactionToUpdate['id'] as int,
                            "type": "Expense",
                            "title": titleController.text.trim(),
                            "remarks": remarksController.text.trim(),
                            "amount": amountController.text.trim(),
                            "dateTime": selectedDate.toString(),
                            "time": selectedTime.toString(),
                            "category": typeChanged
                                ? selectedCategory.toString()
                                : selectedCategory['id'].toString(),
                          };
                          if (formKey.currentState!.validate()) {
                            updateExpense(updatedExpense);

                            sendSnackBar(context, "Transaction Updated");
                            Navigator.of(context).pop();
                          } else {
                            sendSnackBar(context, "Provide necessary info");
                          }
                        } else {
                          var updatedIncome = {
                            "_id": transactionToUpdate['id'] as int,
                            "type": "Income",
                            "title": titleController.text.trim(),
                            "remarks": remarksController.text.trim(),
                            "amount": amountController.text.trim(),
                            "dateTime": selectedDate.toString(),
                            "time": selectedTime.toString(),
                            "category": typeChanged
                                ? selectedCategory.toString()
                                : selectedCategory['id'].toString(),
                          };

                          if (formKey.currentState!.validate()) {
                            updateIncome(updatedIncome);

                            sendSnackBar(context, "Transaction Updated");
                            Navigator.of(context).pop();
                          } else {
                            sendSnackBar(context, "Provide necessary info");
                          }
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
      ),
    );
  }

  Widget _buildRadioOption(String option) {
    return InkWell(
      onTap: () {
        setState(() {
          _transactionType = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _transactionType == option ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _transactionType == option ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          option,
          style: TextStyle(
            color: _transactionType == option ? Colors.white : Colors.black,
            fontWeight: _transactionType == option
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
