import 'package:budget_buddy/Screens/AddCategory.dart';
import 'package:budget_buddy/Screens/AddTransaction.dart';
import 'package:budget_buddy/Screens/Home.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    dynamic appTheme = Provider.of<StateProvider>(context).appTheme;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: appTheme,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/addTransaction': (context) => const AddTransaction(),
        '/addCategory': (context) => const AddCategory(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
