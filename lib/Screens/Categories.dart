import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var TypeToDelete;
  var TitleToDelete;
  deleteCategory() {
    context.read<StateProvider>().deleteCategory(TypeToDelete, TitleToDelete);
  }

  bool _showOverlay = false;

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    var categoryList = Provider.of<StateProvider>(context).categoryList;

    var expenseCategories = [];
    var incomeCategories = [];

    for (var category in categoryList) {
      if (category['type'] == "Expense") {
        expenseCategories.add(category);
      } else {
        incomeCategories.add(category);
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addTransaction");
          },
          child: const Icon(Icons.category),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 4,
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Expense",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "Income",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            expenseCategories.isEmpty
                ? const EmptyListWidget()
                : Stack(
                    children: [
                      ListView.builder(
                        itemCount: expenseCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              child: ListTile(
                                onLongPress: () => {
                                  TypeToDelete = "Expense",
                                  TitleToDelete =
                                      expenseCategories[index]['title'],
                                  _toggleOverlay(),
                                },
                                leading: const Icon(
                                  Icons.temple_buddhist,
                                  color: Colors.red,
                                ),
                                title: Center(
                                  child: Text(
                                    expenseCategories[index]['title'],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (_showOverlay)
                        GestureDetector(
                          onTap: _toggleOverlay,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                              child: Card(
                                color: const Color.fromARGB(255, 212, 216, 219),
                                elevation: 4,
                                margin: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Deleting Item!',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    const Text(
                                      'Are you sure?',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () {
                                            deleteCategory();
                                            _toggleOverlay();
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {
                                            _toggleOverlay();
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
            incomeCategories.isEmpty
                ? const EmptyListWidget()
                : Stack(
                    children: [
                      ListView.builder(
                        itemCount: incomeCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              child: ListTile(
                                onLongPress: () => {
                                  TypeToDelete = "Income",
                                  TitleToDelete =
                                      incomeCategories[index]['title'],
                                  _toggleOverlay()
                                },
                                leading: const Icon(
                                  Icons.temple_buddhist,
                                  color: Colors.green,
                                ),
                                title: Center(
                                  child: Text(
                                    incomeCategories[index]['title'],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (_showOverlay)
                        GestureDetector(
                          onTap: _toggleOverlay,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                              child: Card(
                                color: const Color.fromARGB(255, 212, 216, 219),
                                elevation: 4,
                                margin: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Deleting Item!',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    const Text(
                                      'Are you sure?',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () {
                                            deleteCategory();
                                            _toggleOverlay();
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {
                                            _toggleOverlay();
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
