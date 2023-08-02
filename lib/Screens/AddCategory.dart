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

  List<IconData> iconOptions = [
    Icons.bloodtype,
    Icons.request_quote,
    Icons.directions_bus,
    Icons.local_dining,
    Icons.work,
    Icons.currency_rupee,
    Icons.currency_pound,
    Icons.build,
    Icons.monetization_on,
    Icons.oil_barrel,
    Icons.train,
    Icons.kitchen,
    Icons.house,
    Icons.phone,
    Icons.cake,
    Icons.flight,
    Icons.payment,
    Icons.money,
    Icons.directions_bike,
    Icons.remove_circle,
    Icons.add_circle,
    Icons.find_replace,
    Icons.question_mark,
  ];

  IconData selectedIcon = Icons.local_dining;

  @override
  Widget build(BuildContext context) {
    saveCategory(dynamic type, dynamic title, dynamic icon) async {
      var newCategory = {"type": type, "title": title, "icon": icon.codePoint};
      context.read<StateProvider>().setCategoryList(newCategory);
    }

    sendSnackBar(dynamic message) {
      var snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: _categoryType == "Expense"
          ? const Color.fromARGB(255, 196, 214, 222)
          : const Color.fromARGB(255, 210, 219, 200),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRadioOption("Expense"),
                  const SizedBox(width: 16),
                  _buildRadioOption("Income"),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: titleController,
                  onChanged: (val) {
                    title = val.trim();
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Give a title';
                    }
                    return null;
                  },
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
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: iconOptions.map<Widget>((IconData icon) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: selectedIcon == icon
                            ? Colors.lightBlue
                            : Colors.transparent,
                        child: Icon(
                          icon,
                          color: selectedIcon == icon
                              ? Colors.white
                              : Colors.green,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
                  if (formKey.currentState!.validate()) {
                    saveCategory(_categoryType, title, selectedIcon);
                    sendSnackBar("Category Added");
                    Navigator.of(context).pop();
                  } else {
                    sendSnackBar("Provide the title");
                  }
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
      ),
    );
  }

  Widget _buildRadioOption(String option) {
    return InkWell(
      onTap: () {
        setState(() {
          _categoryType = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _categoryType == option ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _categoryType == option ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            color: _categoryType == option ? Colors.white : Colors.black,
            fontWeight:
                _categoryType == option ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
