import 'package:budget_buddy/Db/DbHelper.dart';
import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
// Importing the databaseHelper
  final dbHelper = DatabaseHelper.instance;
  final dbHelperTransactions = DatabaseHelper.tableTransactions;

// App Settings states
  dynamic _appTheme = Colors.green;
  dynamic get appTheme => _appTheme;

  void setAppTheme(dynamic theme) {
    _appTheme = theme;
    notifyListeners();
  }

  dynamic totalExpenses = 0;
  dynamic totalIncome = 0;

  // Category States
  // final List<dynamic> _categoryList = [
  // {"type": "Expense", "title": "Food & Drinks", "icon": 0xE390},
  // {"type": "Expense", "title": "Transportation", "icon": 0x0E1D5},
  // {"type": "Expense", "title": "Fuel", "icon": 0xF07B7},
  // {"type": "Expense", "title": "Health", "icon": 0x0E0E3},
  // {"type": "Expense", "title": "Household", "icon": 0x0E328},
  // {"type": "Expense", "title": "Lost", "icon": 0x0E517},
  // {"type": "Income", "title": "Salary", "icon": 0x0E6F2},
  // {"type": "Income", "title": "Dakshina", "icon": 0x0E52F},
  // {"type": "Income", "title": "Cashback", "icon": 0xF04DC},
  // {"type": "Income", "title": "Found", "icon": 0x0E04F},
  // ];
  final List<dynamic> _categoryList = [];

  void getCategoriesFromDb() async {
    List<Map<String, dynamic>> cats = await dbHelper.getAllCategories();
    _categoryList.clear();
    for (var cat in cats) {
      var newCategory = {
        "id": cat[DatabaseHelper.colId],
        "type": cat[DatabaseHelper.colType],
        "title": cat[DatabaseHelper.colTitle],
        "icon": cat[DatabaseHelper.colIcon],
      };
      // setCategoryList(newCategory);
      _categoryList.add(newCategory);
      notifyListeners();
    }
  }

  List<dynamic> get categoryList => _categoryList;

  void setCategoryList(dynamic newCategory) async {
    try {
      var category = {
        DatabaseHelper.colType: newCategory['type'],
        DatabaseHelper.colTitle: newCategory['title'],
        DatabaseHelper.colIcon: newCategory['icon'],
      };
      int id = await dbHelper.insertCategory(category);
      // _categoryList.add(category);
      getCategoriesFromDb();
      // notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void deleteCategory(String categoryType, String categoryTitle) async {
    for (var cat in categoryList) {
      if (cat['type'] == categoryType && cat['title'] == categoryTitle) {
        dbHelper.deleteCategory(cat['id']);
        _categoryList.removeWhere(
          (category) =>
              category['type'] == categoryType &&
              category['title'] == categoryTitle,
        );
        notifyListeners();
      }
    }

    var expenseCheckList = 0;
    var incomeCheckList = 0;
    for (dynamic category in _categoryList) {
      if (category['type'] == "Expense") {
        expenseCheckList++;
      } else {
        incomeCheckList++;
      }
    }
    if (expenseCheckList == 0) {
      var newCategory = {
        "type": "Expense",
        "title": "Miscellaneous",
        "icon": 0x0E517
      };
      // _categoryList
      //     .add({"type": "Expense", "title": "Miscellaneous", "icon": 0x0E517});
      setCategoryList(newCategory);
      notifyListeners();
    }
    if (incomeCheckList == 0) {
      var newCategory = {
        "type": "Income",
        "title": "Miscellaneous",
        "icon": 0x0E04F
      };
      // _categoryList.add(
      //   {"type": "Income", "title": "Miscellaneous", "icon": 0x0E04F},
      // );
      setCategoryList(newCategory);
    }
    notifyListeners();
  }

  // Expense Category
  // final List<dynamic> _expenseCategoryList = [
  //   {"type": "Expense", "title": "Food & Drinks", "icon": "Icons.coffee"},
  //   {"type": "Expense", "title": "Transportation", "icon": "Icons.fire_truck"},
  //   {"type": "Expense", "title": "Fuel", "icon": "Icons.oil_barrel"},
  // ];

  // List<dynamic> get expenseCategoryList => _expenseCategoryList;

  // void setExpenseCategoryList(dynamic newCategory) {
  //   _expenseCategoryList.add(newCategory);
  //   notifyListeners();
  // }

  // void deleteExpenseCategory(dynamic categoryId) {
  //   var expenseCategoryToRemove = _expenseCategoryList[categoryId];
  //   _expenseCategoryList.removeAt(categoryId);
  //   notifyListeners();
  // }

  // Income Category
  // final List<dynamic> _incomeCategoryList = [
  //   {"type": "Income", "title": "Salary", "icon": "Icons.money"},
  //   {"type": "Income", "title": "Dakshina", "icon": "Icons.temple_hindu"}
  // ];

  // List<dynamic> get incomeCategoryList => _incomeCategoryList;

  // void setIncomeCategoryList(dynamic newCategory) {
  //   _incomeCategoryList.add(newCategory);
  //   notifyListeners();
  // }

  // void deleteIncomeCategory(dynamic categoryId) {
  //   var incomeCategoryToRemove = _incomeCategoryList[categoryId];
  //   _incomeCategoryList.removeAt(categoryId);
  //   notifyListeners();
  // }

  // Transaction States
  final List<dynamic> _transactionList = [];

  List<dynamic> get transactionList => _transactionList;

  void getTransactionsFromDb() async {
    List<Map<String, dynamic>> transactions =
        await dbHelper.getAllTransactions();
    _transactionList.clear();
    for (var tran in transactions) {
      var newTransaction = {
        "id": tran[DatabaseHelper.colId],
        "type": tran[DatabaseHelper.colType],
        "title": tran[DatabaseHelper.colTitle],
        "amount": tran[DatabaseHelper.colAmount],
        "remarks": tran[DatabaseHelper.colRemarks],
        "dateTime": tran[DatabaseHelper.colDateTime],
        "category": tran[DatabaseHelper.colCategory],
      };
      _transactionList.add(newTransaction);
      if (newTransaction['type'] == "Expense") {
        totalExpenses += double.parse(newTransaction['amount']);
      } else {
        totalIncome += double.parse(newTransaction['amount']);
      }
      notifyListeners();
    }
  }

  void setTransactionList(dynamic newTransaction) async {
    try {
      var transaction = {
        DatabaseHelper.colType: newTransaction['type'],
        DatabaseHelper.colTitle: newTransaction['title'],
        DatabaseHelper.colAmount: newTransaction['amount'],
        DatabaseHelper.colRemarks: newTransaction['remarks'],
        DatabaseHelper.colDateTime: newTransaction['dateTime'],
        DatabaseHelper.colCategory: newTransaction['category'],
      };
      int id = await dbHelper.insertTransaction(transaction);
      getTransactionsFromDb();
    } catch (e) {
      print(e);
    }
  }

  void deleteTransaction(dynamic transactionId) async {
    // dynamic allTransactions = dbHelper.getAllTransactions();
    // for (var transaction in allTransactions) {
    //   print(transaction);
    //   // if (transaction['id'] == transactionId) {
    //   //   if (transaction['type'] == "Expense") {
    //   //     totalExpenses -= double.parse(transaction['amount']);
    //   //     notifyListeners();
    //   //   } else {
    //   //     totalIncome -= double.parse(transaction['amount']);
    //   //     notifyListeners();
    //   //   }
    //   // }
    // }
    dbHelper.deleteTransaction(transactionId);
    getTransactionsFromDb();
    notifyListeners();
  }

  // void getTransactionsFromDb() async {
  //   List<Map<String, dynamic>> transactions =
  //       await dbHelperTransactions.getAllTransactions();
  //   _transactionList.clear();
  //   for (var transaction in transactions) {
  //     var newTransaction = {
  //       "id": transaction[DatabaseHelperTransactions.colId],
  //       "type": transaction[DatabaseHelperTransactions.colType],
  //       "title": transaction[DatabaseHelperTransactions.colTitle],
  //       "amount": transaction[DatabaseHelperTransactions.colAmount],
  //       "remarks": transaction[DatabaseHelperTransactions.colRemarks],
  //       "dateTime": transaction[DatabaseHelperTransactions.colDateTime],
  //       "category": transaction[DatabaseHelperTransactions.colCategory],
  //     };
  //     _transactionList.add(newTransaction);
  //     notifyListeners();
  //   }
  //   print(_transactionList);
  // }

  // void setTransactionsList(dynamic newTransaction) async {
  //   try {
  //     var transaction = {
  //       DatabaseHelperTransactions.colType: newTransaction['type'],
  //       DatabaseHelperTransactions.colTitle: newTransaction['title'],
  //       DatabaseHelperTransactions.colAmount: newTransaction['amount'],
  //       DatabaseHelperTransactions.colRemarks: newTransaction['remarks'],
  //       DatabaseHelperTransactions.colDateTime: newTransaction['dateTime'],
  //       DatabaseHelperTransactions.colCategory: newTransaction['category'],
  //     };
  //     int id = await dbHelperTransactions.insert(transaction);
  //     getTransactionsFromDb();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void setTransactionList(dynamic newTransaction) {
  //   _transactionList.add(newTransaction);
  //   // totalExpenses += double.parse(newTransaction['amount']);

  //   notifyListeners();
  // }

  // void deleteTransaction(dynamic transactionId) {
  //   var transactionToRemove = _transactionList[transactionId];

  //   transactionToRemove['type'] == "Expense"
  //       ? totalExpenses -= double.parse(transactionToRemove['amount'])
  //       : totalIncome -= double.parse(transactionToRemove['amount']);
  //   _transactionList.removeAt(transactionId);

  //   notifyListeners();
  // }

// Expense States
  final List<dynamic> _expenseList = [];

  List<dynamic> get expenseList => _expenseList;

  void setExpenseList(dynamic newExpense) {
    _expenseList.add(newExpense);
    totalExpenses += double.parse(newExpense['amount']);

    notifyListeners();
  }

  void deleteExpense(dynamic expenseId) {
    var expenseToRemove = _expenseList[expenseId];
    totalExpenses -= double.parse(expenseToRemove['amount']);
    notifyListeners();
    transactionList.removeAt(expenseId);
    _expenseList.removeAt(expenseId);

    notifyListeners();
  }

// Income States
  final List<dynamic> _incomeList = [];

  List<dynamic> get incomeList => _incomeList;

  void setIncomeList(dynamic newIncome) {
    _incomeList.add(newIncome);
    totalIncome += double.parse(newIncome['amount']);

    notifyListeners();
  }

  void deleteIncome(dynamic incomeId) {
    var incomeToRemove = _incomeList[incomeId];
    totalIncome -= double.parse(incomeToRemove['amount']);
    transactionList.removeAt(incomeId);
    _incomeList.removeAt(incomeId);

    notifyListeners();
  }
}
