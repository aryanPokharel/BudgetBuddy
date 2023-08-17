import 'package:flutter/material.dart';

Color parseColor(String colorString) {
  try {
    Color? parsedColor = Colors.primaries.firstWhere(
      (color) => color.toString() == colorString,
      orElse: () => Colors.blueGrey,
    );
    return parsedColor ?? Colors.blueGrey;
  } catch (e) {
    return Colors.blueGrey;
  }
}

String colorToString(Color color) {
  return getColorStringFromValue(color.value);
}

Map<int, String> colorValueToNameMap = {
  Colors.red.value: "red",
  Colors.blue.value: "blue",
  Colors.green.value: "green",
  Colors.amber.value: "amber",
  Colors.lightGreen.value: "lightGreen",
  Colors.orange.value: "orange",
  Colors.purple.value: "purple",
  Colors.pink.value: "pink",
};
String getColorStringFromValue(int colorValue) {
  String colorName = colorValueToNameMap[colorValue] ?? "unknown";
  return "Colors.$colorName";
}

Map<String, Color> colorMap = {
  'Colors.red': Colors.red,
  'Colors.blue': Colors.blue,
  'Colors.green': Colors.green,
  'Colors.amber': Colors.amber,
  'Colors.lightGreen': Colors.lightGreen,
  'Colors.orange': Colors.orange,
  'Colors.purple': Colors.purple,
  'Colors.pink': Colors.pink,
};
