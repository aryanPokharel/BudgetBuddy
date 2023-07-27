import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  dynamic totalExpenses = 0;
  dynamic totalIncome = 0;

  // Category States
  final List<dynamic> _categoryList = [
    {"type": "Expense", "title": "Food & Drinks", "icon": 0xE390},
    {"type": "Expense", "title": "Transportation", "icon": 0x0E1D5},
    {"type": "Expense", "title": "Fuel", "icon": 0xF07B7},
    {"type": "Expense", "title": "Travel", "icon": 0xec43},
    {"type": "Income", "title": "Salary", "icon": 0x0E6F2},
    {"type": "Income", "title": "Dakshina", "icon": 0xF04DC},
  ];

  List<dynamic> get categoryList => _categoryList;

  void setCategoryList(dynamic newCategory) {
    _categoryList.add(newCategory);
    notifyListeners();
  }

  void deleteCategory(String categoryType, String categoryTitle) {
    _categoryList.removeWhere(
      (category) =>
          category['type'] == categoryType &&
          category['title'] == categoryTitle,
    );
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

  void setTransactionList(dynamic newTransaction) {
    _transactionList.add(newTransaction);
    // totalExpenses += double.parse(newTransaction['amount']);

    notifyListeners();
  }

  void deleteTransaction(dynamic transactionId) {
    var transactionToRemove = _transactionList[transactionId];

    transactionToRemove['type'] == "Expense"
        ? totalExpenses -= double.parse(transactionToRemove['amount'])
        : totalIncome -= double.parse(transactionToRemove['amount']);
    _transactionList.removeAt(transactionId);

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
    _incomeList.removeAt(incomeId);

    notifyListeners();
  }
}
