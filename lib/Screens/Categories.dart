import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:budget_buddy/AdWidgets/MyAdWidget.dart';
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

    bool darkModeEnabled = Provider.of<StateProvider>(context).darkTheme;

    var appTheme = Provider.of<StateProvider>(context).appTheme;
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
          heroTag: "addCategory",
          onPressed: () {
            Navigator.pushNamed(context, "/addCategory");
          },
          backgroundColor: Colors.white70,
          foregroundColor: darkModeEnabled ? appTheme[700] : appTheme,
          child: const Icon(Icons.add_outlined),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: darkModeEnabled
              ? Color.fromARGB(255, 112, 112, 112)
              : Color.fromARGB(255, 222, 222, 222),
          toolbarHeight: 10,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: TabBar(
              indicatorColor: darkModeEnabled ? Colors.white70 : appTheme,
              tabs: [
                Tab(
                  child: Text(
                    "Expense",
                    style: TextStyle(
                      color: darkModeEnabled ? Colors.white70 : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Income",
                    style: TextStyle(
                      color: darkModeEnabled ? Colors.white70 : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            expenseCategories.isEmpty
                ? const EmptyListWidget()
                : Container(
                    color: darkModeEnabled
                        ? Color.fromARGB(255, 112, 112, 112)
                        : Color.fromARGB(255, 222, 222, 222),
                    child: Stack(
                      children: [
                        ListView.builder(
                          itemCount: expenseCategories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == expenseCategories.length) {
                              return MyAdWidget();
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                color: darkModeEnabled
                                    ? appTheme[700]
                                    : Colors.blue[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    await context
                                        .read<StateProvider>()
                                        .setCategoryToUpdate(
                                            expenseCategories[index]['id']);
                                    Navigator.pushNamed(
                                        context, '/updateCategory');
                                  },
                                  onLongPress: () => {
                                    TypeToDelete = "Expense",
                                    TitleToDelete =
                                        expenseCategories[index]['title'],
                                    _toggleOverlay(),
                                  },
                                  leading: Icon(
                                    IconData(
                                        int.parse(
                                            expenseCategories[index]['icon']),
                                        fontFamily: 'MaterialIcons'),
                                    color: darkModeEnabled
                                        ? Colors.white70
                                        : Colors.brown,
                                    size: 26,
                                  ),
                                  title: Center(
                                    child: Text(
                                      expenseCategories[index]['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: darkModeEnabled
                                          ? Colors.white70
                                          : Color.fromARGB(255, 190, 42, 32),
                                    ),
                                    onPressed: () {
                                      TypeToDelete = "Expense";
                                      TitleToDelete =
                                          expenseCategories[index]['title'];
                                      _toggleOverlay();
                                    },
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
                                  color: Colors.white70,
                                  elevation: 4,
                                  margin: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              deleteCategory();
                                              _toggleOverlay();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
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
                  ),
            incomeCategories.isEmpty
                ? const EmptyListWidget()
                : Container(
                    color: darkModeEnabled
                        ? Color.fromARGB(255, 112, 112, 112)
                        : Color.fromARGB(255, 222, 222, 222),
                    child: Stack(
                      children: [
                        ListView.builder(
                          itemCount: incomeCategories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == incomeCategories.length) {
                              return MyAdWidget();
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                color: darkModeEnabled
                                    ? appTheme[700]
                                    : Colors.blue[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    await context
                                        .read<StateProvider>()
                                        .setCategoryToUpdate(
                                            incomeCategories[index]['id']);
                                    Navigator.pushNamed(
                                        context, '/updateCategory');
                                  },
                                  onLongPress: () => {
                                    TypeToDelete = "Income",
                                    TitleToDelete =
                                        incomeCategories[index]['title'],
                                    _toggleOverlay()
                                  },
                                  leading: Icon(
                                    IconData(
                                        int.parse(
                                            incomeCategories[index]['icon']),
                                        fontFamily: 'MaterialIcons'),
                                    color: darkModeEnabled
                                        ? Colors.white70
                                        : Colors.brown,
                                    size: 26,
                                  ),
                                  title: Center(
                                    child: Text(
                                      incomeCategories[index]['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: darkModeEnabled
                                          ? Colors.white70
                                          : Color.fromARGB(255, 190, 42, 32),
                                    ),
                                    onPressed: () {
                                      TypeToDelete = "Income";
                                      TitleToDelete =
                                          incomeCategories[index]['title'];
                                      _toggleOverlay();
                                    },
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
                                  color: Colors.white70,
                                  elevation: 4,
                                  margin: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              deleteCategory();
                                              _toggleOverlay();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
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
                  ),
          ],
        ),
      ),
    );
  }
}
