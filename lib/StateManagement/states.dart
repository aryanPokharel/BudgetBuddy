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
      await dbHelper.insertCategory(category);
      getCategoriesFromDb();
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
    for (dynamic category in categoryList) {
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
        "icon": "0x0E517"
      };
      // await dbHelper.insertCategory(newCategory);
      setCategoryList(newCategory);
      getCategoriesFromDb();
      notifyListeners();
    }
    if (incomeCheckList == 0) {
      // var newCategory = {
      //   "type": "Income",
      //   "title": "Miscellaneous",
      //   "icon": "0x0E04F"
      // };
      var newCategory = {
        "type": "Income",
        "title": "Miscellaneous",
        "icon": "0x0E04F"
      };

      // await dbHelper.insertCategory(newCategory);
      setCategoryList(newCategory);
      getCategoriesFromDb();
      notifyListeners();
    }
    notifyListeners();
  }

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
    var transaction = {
      DatabaseHelper.colType: newTransaction['type'],
      DatabaseHelper.colTitle: newTransaction['title'],
      DatabaseHelper.colAmount: newTransaction['amount'],
      DatabaseHelper.colRemarks: newTransaction['remarks'],
      DatabaseHelper.colDateTime: newTransaction['dateTime'],
      DatabaseHelper.colCategory: newTransaction['category'],
    };
    await dbHelper.insertTransaction(transaction);
    getTransactionsFromDb();
  }

  void deleteTransaction(dynamic transactionId) async {
    dbHelper.deleteTransaction(transactionId);
    getTransactionsFromDb();
    notifyListeners();
  }

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
