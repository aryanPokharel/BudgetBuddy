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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // dynamic totalExpenses = 0;
  dynamic totalIncome = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    // Call the super.initState() to ensure the state is properly initialized.
    super.initState();

    // context.read<StateProvider>().getTransactionsFromDb();
    context.read<StateProvider>().getCategoriesFromDb();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final List<String> items = ["Hey", "Hello", "Hola", "Bonjour", "Ciao"];
    // Format the DateTime to a human-friendly string
    String formattedDateTime = getFormattedDateTime(now);

    dynamic appTheme = Provider.of<StateProvider>(context).appTheme;
    dynamic totalExpenses = Provider.of<StateProvider>(context).totalExpenses;
    dynamic totalIncome = Provider.of<StateProvider>(context).totalIncome;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_rounded),
            label: 'Insights',
          ),
        ],
      ),
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
                // Handle drawer item tap
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.info),
            //   title: const Text('Insights'),
            //   onTap: () {
            //     // Handle drawer item tap
            //   },
            // ),
          ],
        ),
      ),
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: CarouselSlider.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  items[index],
                  style: const TextStyle(fontSize: 24.0),
                ),
              );
            },
            options: CarouselOptions(
              height: 200.0, // Set the height of the carousel
              enableInfiniteScroll:
                  false, // Set to true if you want the carousel to loop infinitely
              enlargeCenterPage:
                  true, // Set to true if you want the current item to be larger
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [appTheme.shade900, appTheme.shade400],
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
                Card(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Expense",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rs. ${totalExpenses.toStringAsFixed(totalExpenses.truncateToDouble() == totalExpenses ? 0 : 2)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Income",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rs. ${totalIncome.toStringAsFixed(totalIncome.truncateToDouble() == totalIncome ? 0 : 2)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
