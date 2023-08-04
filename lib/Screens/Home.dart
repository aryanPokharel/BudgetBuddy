import 'package:budget_buddy/Constants/DateName.dart';
import 'package:budget_buddy/Constants/DrawerColorButton.dart';
import 'package:budget_buddy/Screens/Categories.dart';
import 'package:budget_buddy/Screens/Expenses.dart';
import 'package:budget_buddy/Screens/Insights.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home"),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.category),
    title: const Text("Categories"),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.info),
    title: const Text("Insights"),
  ),
];

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String getFormattedDateTime(DateTime dateTime) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      // Today
      return getAbbreviatedMonthName(
        today.month.toString(),
        today.year.toString(),
      );
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      // Yesterday
      return getAbbreviatedMonthName(
        yesterday.month.toString(),
        yesterday.year.toString(),
      );
    } else {
      // Format date as "dd MMM"
      return DateFormat('dd MMM').format(dateTime);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<StateProvider>().getCategoriesFromDb();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      "August",
      "September",
      "May",
      "June",
      "July",
    ];

    dynamic appTheme = Provider.of<StateProvider>(context).appTheme;
    dynamic totalExpenses = Provider.of<StateProvider>(context).totalExpenses;
    dynamic totalIncome = Provider.of<StateProvider>(context).totalIncome;

    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: appTheme,
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [appTheme.shade800, Colors.blue.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Choose Theme",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DrawerColorButton(color: Colors.red),
                            DrawerColorButton(color: Colors.blue),
                            DrawerColorButton(color: Colors.green),
                            DrawerColorButton(color: Colors.amber),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DrawerColorButton(color: Colors.lightGreen),
                            DrawerColorButton(color: Colors.blueGrey),
                            DrawerColorButton(color: Colors.purple),
                            DrawerColorButton(color: Colors.pink),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        title: SizedBox(
          height: 50,
          child: CarouselSlider.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  items[index],
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 200,
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          // IconButton(
          //   icon: const Icon(Icons.notifications),
          //   onPressed: () {
          //     // Replace this with your custom functionality
          //   },
          // ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [appTheme.shade300, appTheme.shade900],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Expenses",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs. ${totalExpenses.toStringAsFixed(totalExpenses.truncateToDouble() == totalExpenses ? 0 : 2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Income",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs. ${totalIncome.toStringAsFixed(totalIncome.truncateToDouble() == totalIncome ? 0 : 2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Gross",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs. ${(totalIncome - totalExpenses).toStringAsFixed((totalIncome - totalExpenses).truncateToDouble() == (totalIncome - totalExpenses) ? 0 : 2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            Expenses(),
            Categories(),
            Insights(),
          ],
        ),
      ),
    );
  }
}
