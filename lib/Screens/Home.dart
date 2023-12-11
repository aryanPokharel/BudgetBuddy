import 'package:budget_buddy/Constants/DateName.dart';
import 'package:budget_buddy/Constants/SendSnackBar.dart';
import 'package:budget_buddy/Screens/Categories.dart';
import 'package:budget_buddy/Constants/Constants.dart';
import 'package:budget_buddy/Screens/Insights.dart';
import 'package:budget_buddy/Screens/Transactions.dart';
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
      return getAbbreviatedMonthName(
        today.month.toString(),
        today.year.toString(),
      );
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return getAbbreviatedMonthName(
        yesterday.month.toString(),
        yesterday.year.toString(),
      );
    } else {
      return DateFormat('dd MMM').format(dateTime);
    }
  }

  bool showMonthlyData = true;
  @override
  void initState() {
    super.initState();
    context.read<StateProvider>().fetchAllData();
  }

  final CarouselController _monthListCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<StateProvider>(context).currency;
    String currencySymbol = currencyMap[currency]!;

    bool darkModeEnabled = Provider.of<StateProvider>(context).darkTheme;

    showMonthlyData = Provider.of<StateProvider>(context).showMonthlyData;
    var monthList = months;
    dynamic appTheme = Provider.of<StateProvider>(context).appTheme;
    dynamic totalExpenses = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthTotalExpenses
        : Provider.of<StateProvider>(context).totalExpenses;
    dynamic totalIncome = showMonthlyData
        ? Provider.of<StateProvider>(context).thisMonthTotalIncome
        : Provider.of<StateProvider>(context).totalIncome;
    var selectedMonth = Provider.of<StateProvider>(context).selectedMonth;

    return Scaffold(
      backgroundColor: darkModeEnabled
          ? Color.fromARGB(255, 112, 112, 112)
          : Color.fromARGB(255, 222, 222, 222),
      bottomNavigationBar: SalomonBottomBar(
          backgroundColor: darkModeEnabled
              ? Color.fromARGB(255, 112, 112, 112)
              : Color.fromARGB(255, 222, 222, 222),
          currentIndex: _selectedIndex,
          selectedItemColor: darkModeEnabled ? appTheme[100] : appTheme,
          unselectedItemColor:
              darkModeEnabled ? Colors.white70 : const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
      drawer: Drawer(
        backgroundColor:
            !darkModeEnabled ? Color.fromARGB(255, 222, 222, 222) : null,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: darkModeEnabled
                      ? [
                          Color.fromARGB(255, 34, 42, 46),
                          Color.fromARGB(0, 139, 139, 139)
                        ]
                      : [appTheme, appTheme[200]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
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
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: showMonthlyData
            ? SizedBox(
                height: 50,
                child: CarouselSlider.builder(
                  carouselController: _monthListCarouselController,
                  itemCount: monthList.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        monthList[index],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    initialPage: monthList.indexOf(selectedMonth),
                    onPageChanged:
                        (int index, CarouselPageChangedReason reason) {
                      context.read<StateProvider>().setSelectedMonth(index);
                    },
                  ),
                ))
            : null,
        actions: [
          IconButton(
            onPressed: () {
              sendSnackBar(context, "Upload to cloud comming soon!");
            },
            icon: Icon(Icons.upload_rounded),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Expenses",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$currencySymbol ${totalExpenses.toStringAsFixed(totalExpenses.truncateToDouble() == totalExpenses ? 0 : 2)}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Income",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$currencySymbol ${totalIncome.toStringAsFixed(totalIncome.truncateToDouble() == totalIncome ? 0 : 2)}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Gross",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$currencySymbol ${(totalIncome - totalExpenses).toStringAsFixed((totalIncome - totalExpenses).truncateToDouble() == (totalIncome - totalExpenses) ? 0 : 2)}",
                          style: TextStyle(
                            color: (totalIncome - totalExpenses) > 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Transactions(),
          Categories(),
          InsightsPage(),
        ],
      ),
    );
  }
}
