import 'package:budget_buddy/Constants/DateName.dart';
import 'package:budget_buddy/Constants/SendSnackBar.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String _transactionType = "Expense";

  DateTime? selectedDate = DateTime.now();
  dynamic dateToSend;

  late String foundTitleFieldName;
  late String foundAmountFieldName;
  late String foundDateFieldName;

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
      setState(() {
        selectedDate = pickedDate;
        dateToSend = "${picked.year}-${picked.month}-${picked.day}";
      });

      if (checkTodayYesterday(selectedDate.toString()) == "Day Before") {
        context.read<StateProvider>().setDateFieldBackgroundColor(
              Color.fromARGB(255, 182, 165, 10),
            );
      } else if (checkTodayYesterday(selectedDate.toString()) == "Yesterday") {
        context.read<StateProvider>().setDateFieldBackgroundColor(
              Colors.lightBlue,
            );
      } else if (checkTodayYesterday(selectedDate.toString()) == "Today") {
        context.read<StateProvider>().setDateFieldBackgroundColor(
              Colors.green,
            );
      } else {
        context
            .read<StateProvider>()
            .setDateFieldBackgroundColor(Colors.blueGrey);
      }
    }
  }

  saveExpense(dynamic newExpense) {
    context.read<StateProvider>().saveTransaction(newExpense);
  }

  saveIncome(dynamic newIncome) {
    context.read<StateProvider>().saveTransaction(newIncome);
  }

  clear() {
    titleController.clear();
    amountController.clear();
    remarksController.clear();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  dynamic selectedCategory;
  TimeOfDay selectedTime = TimeOfDay.now();

  var choosenExpenseCategory;
  var choosenIncomeCategory;

  late var picker;
  bool isSendingInvoice = false;

  // Working with interstitial ads

  late InterstitialAd _interstitialAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initAd();
  }

  static const String adUnitId = 'ca-app-pub-9078201720890090/1701830991';
  void _initAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      // test ad uint :
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    setState(() {
      _isLoaded = true;
    });

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
      },
    );
  }

  showInterstitialAd() {
    if (_isLoaded) {
      return _interstitialAd.show();
    } else {
      return (Text("Interstitial ad is not loaded yet."),);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkModeEnabled = Provider.of<StateProvider>(context).darkTheme;
    var categoryList = Provider.of<StateProvider>(context).categoryList;
    var expenseCategories = categoryList
        .where((category) => category['type'] == 'Expense')
        .toList();
    var incomeCategories =
        categoryList.where((category) => category['type'] == 'Income').toList();

    selectedCategory = _transactionType == 'Expense'
        ? expenseCategories[0]['id']
        : incomeCategories[0]['id'];

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

    var dateFieldColor =
        Provider.of<StateProvider>(context).dateFieldBackgroundColor;

    setDateFieldBackgroundColor(var newColor) {
      context.read<StateProvider>().setDateFieldBackgroundColor(newColor);
    }

    return Scaffold(
      backgroundColor: _transactionType == "Expense"
          ? darkModeEnabled
              ? Color.fromARGB(255, 112, 112, 112)
              : Color.fromARGB(255, 196, 214, 222)
          : darkModeEnabled
              ? Color.fromARGB(255, 112, 112, 112)
              : Color.fromARGB(255, 210, 219, 200),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              sendSnackBar(context, "Invoice Reading Coming Soon!");
            },
            icon: Icon(Icons.document_scanner),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: (isSendingInvoice)
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SimpleDialog(
                    title: Text("Processing Image"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LinearProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isSendingInvoice = false;
                            });
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
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
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleController,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          hintText: "Title",
                          filled: true,
                          fillColor: Color.fromARGB(255, 114, 126, 150),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Give a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          hintText: "Amount",
                          filled: true,
                          fillColor: Color.fromARGB(255, 114, 126, 150),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          hintText: "Remarks",
                          filled: true,
                          fillColor: Color.fromARGB(255, 114, 126, 150),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                                setDateFieldBackgroundColor(
                                  Color.fromARGB(255, 182, 165, 10),
                                );
                              });
                            },
                            child: const Text(
                              "DayBefore",
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
                                setDateFieldBackgroundColor(Colors.lightBlue);
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
                                setDateFieldBackgroundColor(Colors.green);
                              });
                            },
                            child: const Text(
                              "Today",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      GestureDetector(
                        onTap: () => {_selectDate(context)},
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: dateFieldColor,
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
                                  selectedDate == null
                                      ? 'Please select a date'
                                      : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    fontSize: 16,
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
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 215, 73, 85),
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
                                  selectedDate == null
                                      ? 'Please select time'
                                      : selectedTime.format(context),
                                  style: const TextStyle(
                                    fontSize: 16,
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
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/addCategory');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 114, 126, 150),
                          minimumSize: Size(400, 30),
                        ),
                        child: Text("Create Own Category"),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField<dynamic>(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        value: _transactionType == "Expense"
                            ? expenseCategories[0]
                            : incomeCategories[0],
                        items: _transactionType == "Expense"
                            ? expenseCategories.map((dynamic category) {
                                final Map<String, dynamic> categoryData =
                                    category as Map<String, dynamic>;
                                return DropdownMenuItem<dynamic>(
                                  value: category,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          IconData(
                                              int.parse(categoryData['icon']),
                                              fontFamily: 'MaterialIcons'),
                                          color: !darkModeEnabled
                                              ? Color.fromARGB(255, 0, 0, 0)
                                              : null,
                                        ),
                                        const SizedBox(
                                          width: 110,
                                        ),
                                        Text(
                                          categoryData['title'],
                                          style: TextStyle(
                                            color: !darkModeEnabled
                                                ? Color.fromARGB(255, 0, 0, 0)
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()
                            : incomeCategories.map((dynamic category) {
                                final Map<String, dynamic> categoryData =
                                    category as Map<String, dynamic>;
                                return DropdownMenuItem<dynamic>(
                                  value: category,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        IconData(
                                            int.parse(categoryData['icon']),
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
                          _transactionType == "Expense"
                              ? choosenExpenseCategory = value
                              : choosenIncomeCategory = value;
                          selectedCategory = value['id'];
                        },
                        decoration: const InputDecoration(
                          hintText: "Select category",
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                          ElevatedButton(
                            onPressed: () {
                              showInterstitialAd();
                              if (_transactionType == "Expense") {
                                var newExpense = {
                                  "type": "Expense",
                                  "title": titleController.text.trim(),
                                  "remarks": remarksController.text.trim(),
                                  "amount": amountController.text.trim(),
                                  "dateTime": selectedDate.toString(),
                                  "time": selectedTime.toString(),
                                  "category": selectedCategory,
                                };

                                if (formKey.currentState!.validate()) {
                                  saveExpense(newExpense);
                                  sendSnackBar(context, "Expense Added");
                                  Navigator.of(context).pop();
                                } else {
                                  sendSnackBar(
                                      context, "Provide necessary info");
                                }
                              } else {
                                var newIncome = {
                                  "type": "Income",
                                  "title": titleController.text.trim(),
                                  "remarks": remarksController.text.trim(),
                                  "amount": amountController.text.trim(),
                                  "dateTime": selectedDate.toString(),
                                  "time": selectedTime.toString(),
                                  "category": selectedCategory.toString(),
                                };

                                if (formKey.currentState!.validate()) {
                                  saveIncome(newIncome);
                                  sendSnackBar(context, "Income Added");
                                  Navigator.of(context).pop();
                                } else {
                                  sendSnackBar(
                                      context, "Provide necessary info");
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
