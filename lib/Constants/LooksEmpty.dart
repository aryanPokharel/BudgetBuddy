import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.pending,
          size: 100,
          color: Colors.grey,
        ),
        SizedBox(height: 16),
        Text(
          "Whoops! It's empty here",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    );
  }
}
