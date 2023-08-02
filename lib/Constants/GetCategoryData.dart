import 'package:budget_buddy/Db/DbHelper.dart';

final dbHelper = DatabaseHelper.instance;

dynamic getCategoryIcon(dynamic categoryId) async {
  Map<String, dynamic>? categoryData =
      await dbHelper.getCategoryById(categoryId);
  String iconData = categoryData!['icon'];
  return iconData;
}
