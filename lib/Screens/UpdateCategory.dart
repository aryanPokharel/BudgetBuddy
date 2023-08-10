import 'package:budget_buddy/Constants/IconList.dart';
import 'package:budget_buddy/Constants/ParseIconData.dart';
import 'package:budget_buddy/Constants/SendSnackBar.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateCategory extends StatefulWidget {
  const UpdateCategory({super.key});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  late dynamic categoryToUpdate;
  var titleController = TextEditingController();
  var iconController = TextEditingController();
  late String _categoryType;
  late IconData selectedIcon;
  updateCategory(dynamic updatedCategory) {
    print("Updating category");
    context.read<StateProvider>().updateCategory(updatedCategory);
    print("Category Updated");
  }

  @override
  void initState() {
    super.initState();
    categoryToUpdate =
        Provider.of<StateProvider>(context, listen: false).categoryToUpdate;
    ;

    _categoryType = categoryToUpdate['type'];
    titleController.text = categoryToUpdate['title'];
    selectedIcon = getReadableIconData(categoryToUpdate['icon']);
  }

  @override
  Widget build(BuildContext context) {
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                ),
                itemCount: iconList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = iconList[index];
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: selectedIcon == iconList[index]
                          ? Colors.lightBlue
                          : Colors.transparent,
                      child: Icon(
                        iconList[index],
                        color: selectedIcon == iconList[index]
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                },
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
                    String hexCodePoint =
                        '0x${selectedIcon.codePoint.toRadixString(16).toUpperCase()}';
                    var updatedCategory = {
                      "_id": categoryToUpdate['id'],
                      "type": _categoryType,
                      "title": titleController.text.trim(),
                      "icon": hexCodePoint,
                    };
                    updateCategory(updatedCategory);
                    sendSnackBar(context, "Category Updated");
                    Navigator.of(context).pop();
                  } else {
                    sendSnackBar(context, "Provide the title");
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text(
                      'Update Category',
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
