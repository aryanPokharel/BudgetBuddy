import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  // Working with constants
  dynamic totalExpenses = 0;

  final List<dynamic> _expenseList = [];

  List<dynamic> get expenseList => _expenseList;

  void setExpenseList(dynamic newExpense) {
    _expenseList.add(newExpense);
    totalExpenses += double.parse(newExpense['amount']);

    notifyListeners();
  }

  void deleteExpense(dynamic expenseId) {
    var expenseToRemove = _expenseList[expenseId];
    totalExpenses -= expenseToRemove['amount'];
    _expenseList.removeAt(expenseId);

    notifyListeners();
  }
}
