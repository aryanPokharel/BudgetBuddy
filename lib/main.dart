import 'package:budget_buddy/Screens/Home.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    ));
  }
}
