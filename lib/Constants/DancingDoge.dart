import 'package:flutter/material.dart';

class DancingDoge extends StatefulWidget {
  const DancingDoge({super.key});

  @override
  State<DancingDoge> createState() => _DancingDogeState();
}

class _DancingDogeState extends State<DancingDoge> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/gifs/dancingDoge.gif",
          height: 100,
          width: 100,
        ),
        SizedBox(height: 16),
        Text(
          "Waiting for some data...",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    );
  }
}
