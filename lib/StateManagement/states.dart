import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  final List<dynamic> _expenseList = [
    {"title": "HairCut", "price": "100", "description": "Trimmed my hair"},
    {"title": "Movie", "price": "300", "description": "Watched Oppenheimer."}
  ];

  List<dynamic> get expenseList => _expenseList;

  void setExpenseList(dynamic newExpense) {
    _expenseList.add(newExpense);
    notifyListeners();
  }
}
