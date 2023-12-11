import 'package:budget_buddy/Screens/AddCategory.dart';
import 'package:budget_buddy/Screens/AddTransaction.dart';
import 'package:budget_buddy/Screens/Settings.dart';
import 'package:budget_buddy/Screens/SplashScreen.dart';
import 'package:budget_buddy/Screens/UpdateCategory.dart';
import 'package:budget_buddy/Screens/UpdateTransaction.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    ChangeNotifierProvider<StateProvider>(
      create: (_) => StateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);

    return MaterialApp(
      theme: stateProvider.darkTheme
          ? ThemeData.dark()
          : ThemeData(primarySwatch: stateProvider.appTheme),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/addTransaction': (context) => const AddTransaction(),
        '/addCategory': (context) => const AddCategory(),
        '/settings': (context) => const SettingsPage(),
        '/updateTransaction': (context) => const UpdateTransaction(),
        '/updateCategory': (context) => const UpdateCategory(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
