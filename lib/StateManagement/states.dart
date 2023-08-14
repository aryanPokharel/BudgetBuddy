import 'dart:async';

import 'package:budget_buddy/Constants/ConstantValues.dart';
import 'package:budget_buddy/Constants/DateName.dart';
import 'package:budget_buddy/Constants/TryParseDouble.dart';
import 'package:budget_buddy/Db/DbHelper.dart';
import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  bool dataLoaded = false;

// Fetch All Data
  fetchAllData() async {
    await getCategoriesFromDb();
    await getTransactionsFromDb();
    await categorizeTransactions();
    await giveTitlesToCategoryTypes();
    buildMonthList();
    dataLoaded = true;
    notifyListeners();
  }

// Importing the databaseHelper
  final dbHelper = DatabaseHelper.instance;

// App Settings states
  dynamic _appTheme = defaultAppTheme;
  dynamic get appTheme => _appTheme;

  void setAppTheme(dynamic theme) {
    _appTheme = theme;
    notifyListeners();
  }

  dynamic totalExpenses = 0;
  dynamic totalIncome = 0;

  dynamic thisMonthTotalExpenses = 0;
  dynamic thisMonthTotalIncome = 0;

// Category states
  dynamic toUpdateCategoryId = 0;
  final List<dynamic> _categoryList = [];

  getCategoriesFromDb() async {
    List<Map<String, dynamic>> cats = await dbHelper.getAllCategories();
    var expenseCheckList = 0;
    var incomeCheckList = 0;
    for (dynamic category in cats) {
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
      await dbHelper.insertCategory(newCategory);
      cats = await dbHelper.getAllCategories();
    } else if (incomeCheckList == 0) {
      var newCategory = {
        "type": "Income",
        "title": "Miscellaneous",
        "icon": "0x0E04F"
      };
      await dbHelper.insertCategory(newCategory);
      cats = await dbHelper.getAllCategories();
    }

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
    buildMonthList();
  }

  List<dynamic> get categoryList => _categoryList;

  void setCategoryList(dynamic newCategory) async {
    var category = {
      DatabaseHelper.colType: newCategory['type'],
      DatabaseHelper.colTitle: newCategory['title'],
      DatabaseHelper.colIcon: newCategory['icon'],
    };
    await dbHelper.insertCategory(category);
    getCategoriesFromDb();
    // buildMonthList();
  }

  dynamic categoryToUpdate = {};
  updateCategory(dynamic updatedCategory) async {
    await dbHelper.updateCategory(updatedCategory);
    getCategoriesFromDb();
  }

  Future setCategoryToUpdate(dynamic categoryId) async {
    toUpdateCategoryId = categoryId;
    var receivedCategory = await dbHelper.getCategoryById(categoryId);
    categoryToUpdate['id'] = receivedCategory!['_id'];
    categoryToUpdate['type'] = receivedCategory['type'];
    categoryToUpdate['title'] = receivedCategory['title'];
    categoryToUpdate['icon'] = receivedCategory['icon'];
    notifyListeners();
  }

  deleteCategory(String categoryType, String categoryTitle) async {
    for (var cat in categoryList) {
      if (cat['type'] == categoryType && cat['title'] == categoryTitle) {
        dbHelper.deleteCategory(cat['id']);
        getCategoriesFromDb();
      }
    }
    notifyListeners();
  }

  // Transaction States
// Constant values
  dynamic toUpdateTransactionId = 0;

  var transactionToUpdate = {};
  dynamic toUpdateType = "";
  dynamic toUpdateTitle = "";
  dynamic toUpdateAmount = "";
  dynamic toUpdateRemarks = "";
  dynamic toUpdateDate = "";

  dynamic toUpdateTime = "";
  dynamic toUpdateCategory = "";

  Future setTransactionToUpdate(dynamic transactionId) async {
    toUpdateTransactionId = transactionId;
    var receivedTransaction =
        await dbHelper.getTransactionById(toUpdateTransactionId);
    transactionToUpdate['id'] = receivedTransaction!['_id'];
    transactionToUpdate['type'] = receivedTransaction['type'];
    transactionToUpdate['title'] = receivedTransaction['title'];
    transactionToUpdate['amount'] = receivedTransaction['amount'];
    transactionToUpdate['remarks'] = receivedTransaction['remarks'];
    transactionToUpdate['dateTime'] = receivedTransaction['dateTime'];
    transactionToUpdate['time'] = receivedTransaction['time'];
    transactionToUpdate['category'] = receivedTransaction['category'];

    notifyListeners();
  }

  final List<dynamic> _transactionList = [];
  List<dynamic> get transactionList => _transactionList;
  List<dynamic> _thisMonthTransactionList = [];
  List<dynamic> get thisMonthTransactionList => _thisMonthTransactionList;

  getTransactionsFromDb() async {
    // For Gross transactions
    totalExpenses = 0;
    totalIncome = 0;

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
        "time": tran[DatabaseHelper.colTime],
        "category": tran[DatabaseHelper.colCategory],
      };

      _transactionList.add(newTransaction);
      if (newTransaction['type'] == "Expense") {
        totalExpenses += double.parse(newTransaction['amount']);
        notifyListeners();
      } else {
        totalIncome += double.parse(newTransaction['amount']);
        notifyListeners();
      }
    }

    buildMonthList();
    // For this month transactions
    // For monthly
    thisMonthTotalExpenses = 0;
    thisMonthTotalIncome = 0;
    List<Map<String, dynamic>> thisMonthTransactions = [];
    _thisMonthTransactionList.clear();

    for (var tran in transactions) {
      var newTransaction = {
        "id": tran[DatabaseHelper.colId],
        "type": tran[DatabaseHelper.colType],
        "title": tran[DatabaseHelper.colTitle],
        "amount": tran[DatabaseHelper.colAmount],
        "remarks": tran[DatabaseHelper.colRemarks],
        "dateTime": tran[DatabaseHelper.colDateTime],
        "time": tran[DatabaseHelper.colTime],
        "category": tran[DatabaseHelper.colCategory],
      };

      if (getMonthName(newTransaction['dateTime']) == selectedMonth) {
        thisMonthTransactionList.add(newTransaction);
        thisMonthTransactions.add(newTransaction);
        if (newTransaction['type'] == "Expense") {
          thisMonthTotalExpenses += double.parse(newTransaction['amount']);
          notifyListeners();
        } else {
          thisMonthTotalIncome += double.parse(newTransaction['amount']);
          notifyListeners();
        }
      }
    }

    categorizeTransactions();
    buildMonthList();
    notifyListeners();
  }

  void setTransactionList(dynamic newTransaction) async {
    var transaction = {
      DatabaseHelper.colType: newTransaction['type'],
      DatabaseHelper.colTitle: newTransaction['title'],
      DatabaseHelper.colAmount: newTransaction['amount'],
      DatabaseHelper.colRemarks: newTransaction['remarks'],
      DatabaseHelper.colDateTime: newTransaction['dateTime'],
      DatabaseHelper.colTime: newTransaction['time'],
      DatabaseHelper.colCategory: newTransaction['category'],
    };

    await dbHelper.insertTransaction(transaction);
    getTransactionsFromDb();
    buildMonthList();
  }

  updateTransaction(dynamic updatedTransaction) async {
    await dbHelper.updateTransaction(updatedTransaction);
    getTransactionsFromDb();
  }

  deleteTransaction(dynamic transactionId) async {
    await dbHelper.deleteTransaction(transactionId);
    getTransactionsFromDb();
  }

  var expenseCategoryTypesTitles = [];
  var incomeCategoryTypesTitles = [];

  var thisMonthExpenseCategoryTypesTitles = [];
  var thisMonthIncomeCategoryTypesTitles = [];
  giveTitlesToCategoryTypes() async {
    // Temporary lists for expense and income titles
    List<String> tempExpenseTitles = [];
    List<String> tempIncomeTitles = [];

    List<String> tempThisMonthExpenseTitles = [];
    List<String> tempThisMonthIncomeTitles = [];

    // Expense categories
    for (var expenseCategoryType in expenseCategoryTypes) {
      var category = await dbHelper.getCategoryById(expenseCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempExpenseTitles.add(title);
    }

    // Income categories
    for (var incomeCategoryType in incomeCategoryTypes) {
      var category = await dbHelper.getCategoryById(incomeCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempIncomeTitles.add(title);
    }

    // For this month
    // Expense categories
    for (var thisMonthExpenseCategoryType in thisMonthExpenseCategoryTypes) {
      var category =
          await dbHelper.getCategoryById(thisMonthExpenseCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempThisMonthExpenseTitles.add(title);
    }

    // Income categories
    for (var thisMonthIncomeCategoryType in thisMonthIncomeCategoryTypes) {
      var category =
          await dbHelper.getCategoryById(thisMonthIncomeCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempThisMonthIncomeTitles.add(title);
    }

    // Set the main lists after collecting all titles
    expenseCategoryTypesTitles = tempExpenseTitles;
    incomeCategoryTypesTitles = tempIncomeTitles;

    thisMonthExpenseCategoryTypesTitles = tempThisMonthExpenseTitles;
    thisMonthIncomeCategoryTypesTitles = tempThisMonthIncomeTitles;
  }

  var expenseCategoryTypes = [];
  var incomeCategoryTypes = [];

  var thisMonthExpenseCategoryTypes = [];
  var thisMonthIncomeCategoryTypes = [];

  categorizeTransactions() {
    expenseCategoryTypes = [];
    incomeCategoryTypes = [];

    thisMonthExpenseCategoryTypes = [];
    thisMonthIncomeCategoryTypes = [];

    // For gross data
    for (var transaction in transactionList) {
      if (transaction['type'] == 'Expense') {
        // For expense categories
        double expenseCategoryTotalAmount =
            tryParseDouble(transaction['amount']);
        bool found = false;
        for (var category in expenseCategoryTypes) {
          if (transaction['category'] == category['id']) {
            found = true;
            category['totalAmount'] += expenseCategoryTotalAmount;
            break;
          }
        }
        if (!found) {
          expenseCategoryTypes.add({
            "id": transaction['category'],
            "totalAmount": expenseCategoryTotalAmount,
          });
        }
      } else {
        // For income categories
        double incomeCategoryTotalAmount =
            tryParseDouble(transaction['amount']);
        bool found = false;
        for (var category in incomeCategoryTypes) {
          if (transaction['category'] == category['id']) {
            found = true;
            category['totalAmount'] += incomeCategoryTotalAmount;
            break; // Exit the loop once a match is found
          }
        }
        if (!found) {
          incomeCategoryTypes.add({
            "id": transaction['category'],
            "totalAmount": incomeCategoryTotalAmount,
          });
        }
      }
      notifyListeners();
    }

    // For this month data

    for (var transaction in thisMonthTransactionList) {
      if (transaction['type'] == 'Expense') {
        // For expense categories
        double thisMonthExpenseCategoryTotalAmount =
            tryParseDouble(transaction['amount']);
        bool found = false;
        for (var category in thisMonthExpenseCategoryTypes) {
          if (transaction['category'] == category['id']) {
            found = true;
            category['totalAmount'] += thisMonthExpenseCategoryTotalAmount;
            break; // Exit the loop once a match is found
          }
        }
        if (!found) {
          thisMonthExpenseCategoryTypes.add({
            "id": transaction['category'],
            "totalAmount": thisMonthExpenseCategoryTotalAmount,
          });
        }
      } else {
        // For income categories
        double thisMonthIncomeCategoryTotalAmount =
            tryParseDouble(transaction['amount']);
        bool found = false;
        for (var category in thisMonthIncomeCategoryTypes) {
          if (transaction['category'] == category['id']) {
            found = true;
            category['totalAmount'] += thisMonthIncomeCategoryTotalAmount;
            break; // Exit the loop once a match is found
          }
        }
        if (!found) {
          thisMonthIncomeCategoryTypes.add({
            "id": transaction['category'],
            "totalAmount": thisMonthIncomeCategoryTotalAmount,
          });
        }
      }
      notifyListeners();
    }

    giveTitlesToCategoryTypes();
    notifyListeners();
  }

  // Listing the available  months :
  var selectedMonth;

  dynamic monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  buildMonthList() {
    monthList.clear();
    _transactionList.forEach((transaction) {
      if (monthList.length < 1) {
        monthList.add(
          getMonthName(transaction['dateTime']),
        );
      } else {
        bool found = false;
        for (var monthInList in monthList) {
          if (monthInList == getMonthName(transaction['dateTime'])) {
            found = true;
            break;
          }
        }
        if (!found) {
          monthList.add(
            getMonthName(transaction['dateTime']),
          );
        }
      }
    });
    notifyListeners();
  }

  setSelectedMonth(int index) {
    selectedMonth = monthList[index];
    getTransactionsFromDb();
    // notifyListeners();
  }

  // End of Transaction States
}
