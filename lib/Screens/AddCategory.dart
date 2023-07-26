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

  // List<IconData> incomeIcons = [
  //   Icons.money,
  //   Icons.currency_bitcoin,
  //   Icons.gesture,
  //   Icons.handshake,
  //   Icons.find_replace,
  // ];

  // Declare a variable to store the selected icon
  IconData selectedIcon = Icons.local_dining;

  @override
  Widget build(BuildContext context) {
    saveCategory(dynamic type, dynamic title, dynamic icon) {
      var newCategory = {"type": type, "title": title, "icon": icon.codePoint};
      print(newCategory);
      context.read<StateProvider>().setCategoryList(newCategory);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
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
                const Text("Expense"),
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
                const Text("Income"),
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
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Icon'),
                  SizedBox(
                    width: 100,
                    child: DropdownButton<IconData>(
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
                              color: Colors.lightGreen,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                saveCategory(_categoryType, title, selectedIcon);
              },
              child: const Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
