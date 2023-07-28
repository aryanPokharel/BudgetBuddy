import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerColorButton extends StatelessWidget {
  final Color color;

  const DrawerColorButton({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<StateProvider>().setAppTheme(color);
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: const Center(
          child: Text(
            '', // You can leave this empty or add a text if you want
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
