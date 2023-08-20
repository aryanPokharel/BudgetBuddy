import 'package:budget_buddy/Constants/DateName.dart';
import 'package:budget_buddy/Constants/ParseColor.dart';
import 'package:budget_buddy/Constants/TryParseDouble.dart';
import 'package:budget_buddy/Db/DbHelper.dart';
import 'package:budget_buddy/Screens/Constants.dart';
import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  bool dataLoaded = false;

  bool showMonthlyData = true;

  setShowMonthlyData(bool value) {
    showMonthlyData = value;
    notifyListeners();
  }

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
    "December",
  ];

  var selectedMonth = "August";

// Fetch All Data
  fetchAllData() async {
    await getCategoriesFromDb();

    await getTransactionsFromDb();
    await categorizeTransactions();
    await giveTitlesToCategoryTypes();

    await buildThisMonthTransactions();
    await categorizeThisMonthTransactions();
    await giveTitlesToThisMonthCategoryTypes();

    await getAppSettings();
    notifyListeners();
  }

// Importing the databaseHelper
  final dbHelper = DatabaseHelper.instance;

// App Settings states
  dynamic _appTheme = defaultAppTheme;
  dynamic get appTheme => _appTheme;

  // Working with app Settings

  bool darkTheme = false;
  getAppSettings() async {
    await dbHelper.getAppSettings().then((value) {
      if (value[0]['appTheme'] == "Dark") {
        darkTheme = true;
        _appTheme = Colors.blueGrey;
      } else {
        darkTheme = false;
        _appTheme = colorMap[value[0]['themeColor']] ?? Colors.blue;
      }
      notifyListeners();
    });
  }

  setAppColor() async {
    dynamic updatedAppSetting;
    await dbHelper.getAppSettings().then((value) {
      _appTheme = colorMap[value[0]['themeColor']];
      darkTheme = false;

      notifyListeners();
    });
    updatedAppSetting = {
      "_id": 1,
      "appTheme": "Light",
    };
    await dbHelper.updateAppSettings(updatedAppSetting);
    notifyListeners();
  }

  updateAppTheme(String mode, dynamic updatedAppTheme) async {
    dynamic updatedAppSetting;
    if (mode == "Dark") {
      darkTheme = true;
      updatedAppSetting = {
        "_id": 1,
        "appTheme": mode,
      };
    } else {
      darkTheme = false;
      updatedAppSetting = {
        "_id": 1,
        "appTheme": mode,
        "themeColor": colorToString(updatedAppTheme),
      };
    }

    await dbHelper.updateAppSettings(updatedAppSetting);
    getAppSettings();
  }

  dynamic totalExpenses = 0;
  dynamic totalIncome = 0;

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
  }

  List<dynamic> get categoryList => _categoryList;

  void saveCategory(dynamic newCategory) async {
    var category = {
      DatabaseHelper.colType: newCategory['type'],
      DatabaseHelper.colTitle: newCategory['title'],
      DatabaseHelper.colIcon: newCategory['icon'],
    };
    await dbHelper.insertCategory(category);
    getCategoriesFromDb();
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
  }

  // Transaction States
  final List<dynamic> transactionList = [];
  getTransactionsFromDb() async {
    totalExpenses = 0;
    totalIncome = 0;
    List<Map<String, dynamic>> transactions =
        await dbHelper.getAllTransactions();
    transactionList.clear();
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
      transactionList.add(newTransaction);
      if (newTransaction['type'] == "Expense") {
        totalExpenses += double.parse(newTransaction['amount']);
      } else {
        totalIncome += double.parse(newTransaction['amount']);
      }
    }
    categorizeTransactions();
    buildThisMonthTransactions();
    notifyListeners();
  }

  void saveTransaction(dynamic newTransaction) async {
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
  }

  dynamic toUpdateTransactionId = 0;
  var transactionToUpdate = {};
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

  updateTransaction(dynamic updatedTransaction) async {
    await dbHelper.updateTransaction(updatedTransaction);
    getTransactionsFromDb();
    notifyListeners();
  }

  deleteTransaction(dynamic transactionId) async {
    await dbHelper.deleteTransaction(transactionId);
    getTransactionsFromDb();
    notifyListeners();
  }

  var expenseCategoryTypes = [];
  var incomeCategoryTypes = [];
  categorizeTransactions() {
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
    }
    giveTitlesToCategoryTypes();
    notifyListeners();
  }

  var expenseCategoryTypesTitles = [];
  var incomeCategoryTypesTitles = [];

  giveTitlesToCategoryTypes() async {
    List<String> tempExpenseTitles = [];
    List<String> tempIncomeTitles = [];

    for (var expenseCategoryType in expenseCategoryTypes) {
      var category = await dbHelper.getCategoryById(expenseCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempExpenseTitles.add(title);
    }
    for (var incomeCategoryType in incomeCategoryTypes) {
      var category = await dbHelper.getCategoryById(incomeCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempIncomeTitles.add(title);
    }
    expenseCategoryTypesTitles = tempExpenseTitles;
    incomeCategoryTypesTitles = tempIncomeTitles;
  }

  // Working with this month
  dynamic thisMonthTotalExpenses = 0;
  dynamic thisMonthTotalIncome = 0;
  setSelectedMonth(int month) {
    selectedMonth = monthList[month];

    fetchAllData();
    notifyListeners();
  }

  var thisMonthCategories = [];
  var thisMonthTransactions = [];
  buildThisMonthTransactions() {
    thisMonthTotalExpenses = 0;
    thisMonthTotalIncome = 0;
    thisMonthTransactions.clear();
    for (var transaction in transactionList) {
      if (getMonthName(transaction['dateTime'].toString()) == selectedMonth) {
        thisMonthTransactions.add(transaction);
        if (transaction['type'] == "Expense") {
          thisMonthTotalExpenses += double.parse(transaction['amount']);
        } else {
          thisMonthTotalIncome += double.parse(transaction['amount']);
        }
      }
    }
    categorizeThisMonthTransactions();
    notifyListeners();
  }

  var thisMonthExpenseCategoryTypes = [];
  var thisMonthIncomeCategoryTypes = [];
  categorizeThisMonthTransactions() {
    for (var transaction in thisMonthTransactions) {
      if (transaction['type'] == 'Expense') {
        // For expense categories
        double thisMonthExpenseCategoryTotalAmount =
            tryParseDouble(transaction['amount']);
        bool found = false;
        for (var category in thisMonthExpenseCategoryTypes) {
          if (transaction['category'] == category['id']) {
            found = true;
            category['totalAmount'] += thisMonthExpenseCategoryTotalAmount;
            break;
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
    }
    giveTitlesToThisMonthCategoryTypes();
    notifyListeners();
  }

  var thisMonthExpenseCategoryTypesTitles = [];
  var thisMonthIncomeCategoryTypesTitles = [];

  giveTitlesToThisMonthCategoryTypes() async {
    List<String> tempExpenseTitles = [];
    List<String> tempIncomeTitles = [];

    for (var expenseCategoryType in expenseCategoryTypes) {
      var category = await dbHelper.getCategoryById(expenseCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempExpenseTitles.add(title);
    }
    for (var incomeCategoryType in incomeCategoryTypes) {
      var category = await dbHelper.getCategoryById(incomeCategoryType['id']);
      var title = category![DatabaseHelper.colTitle];
      tempIncomeTitles.add(title);
    }
    expenseCategoryTypesTitles = tempExpenseTitles;
    incomeCategoryTypesTitles = tempIncomeTitles;
  }
}
