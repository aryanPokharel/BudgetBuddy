import 'package:budget_buddy/Constants/LooksEmpty.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var categoryList = [];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                categoryList.isEmpty
                    ? const EmptyListWidget()
                    : ListView.builder(
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return const Text("haha");
                        },
                      ),
              ],
            )));
  }
}
