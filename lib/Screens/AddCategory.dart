import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var titleController = TextEditingController();
  var iconController = TextEditingController();

  String _categoryType = "Expense";

  var title;

  List<IconData> expenseIcons = [
    Icons.liquor,
    Icons.local_dining,
    Icons.oil_barrel,
    Icons.train,
    Icons.payment,
    Icons.money,
    Icons.add_box_rounded,
    Icons.electric_bike,
    Icons.find_replace,
    Icons.question_mark,
  ];

  IconData selectedIcon = Icons.local_dining;

  @override
  Widget build(BuildContext context) {
    saveCategory(dynamic type, dynamic title, dynamic icon) {
      var newCategory = {"type": type, "title": title, "icon": icon.codePoint};
      context.read<StateProvider>().setCategoryList(newCategory);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Radio(
                  value: "Expense",
                  groupValue: _categoryType,
                  onChanged: (value) {
                    setState(() {
                      _categoryType = value.toString();
                    });
                  },
                ),
                const Text(
                  "Expense",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Radio(
                  value: "Income",
                  groupValue: _categoryType,
                  onChanged: (value) {
                    setState(() {
                      _categoryType = value.toString();
                    });
                  },
                ),
                const Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: titleController,
              onChanged: (val) {
                setState(() {
                  title = val;
                });
              },
              decoration: const InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Icon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<IconData>(
              value: selectedIcon,
              onChanged: (IconData? newValue) {
                setState(() {
                  selectedIcon = newValue!;
                });
              },
              items: expenseIcons.map<DropdownMenuItem<IconData>>(
                (IconData icon) {
                  return DropdownMenuItem<IconData>(
                    value: icon,
                    child: Icon(
                      icon,
                      color: Colors.green,
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                saveCategory(_categoryType, title, selectedIcon);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 8),
                  Text(
                    'Save Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
