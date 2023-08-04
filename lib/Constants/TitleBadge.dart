import 'package:flutter/material.dart';

class TitleBadge extends StatelessWidget {
  final String title;
  final Color bgColor;
  const TitleBadge({Key? key, required this.title, required this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: bgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
