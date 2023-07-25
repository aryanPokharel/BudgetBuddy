import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  final List<dynamic> _expenseList = [];

  List<dynamic> get expenseList => _expenseList;

  void setExpenseList(dynamic newExpense) {
    _expenseList.add(newExpense);
    notifyListeners();
  }

  void deleteExpense(dynamic expenseId) {
    _expenseList.removeAt(expenseId);
    notifyListeners();
  }
}
