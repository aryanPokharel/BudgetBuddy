import 'package:budget_buddy/Screens/Home.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StateProvider>().fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    bool dataLoaded = Provider.of<StateProvider>(context).dataLoaded;
    return Scaffold(
      backgroundColor: Colors.black,
      body: dataLoaded
          ? HomePage()
          : Center(
              child: Image.asset(
                'assets/icons/SoftwareBhatti.png',
                height: MediaQuery.of(context).size.height * 0.80,
                width: MediaQuery.of(context).size.width * 0.80,
              ),
            ),
    );
  }
}
