import 'package:flutter/material.dart';

Color parseColor(String colorString) {
  try {
    Color? parsedColor = Colors.primaries.firstWhere(
      (color) => color.toString() == colorString,
      orElse: () => Colors.blueGrey,
    );
    return parsedColor;
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
  Colors.teal.value: "teal",
  Colors.amber.value: "amber",
  Colors.brown.value: "brown",
  Colors.purple.value: "purple",
  Colors.pink.value: "pink",
  Colors.blueGrey.value: "blueGrey",
};
String getColorStringFromValue(int colorValue) {
  String colorName = colorValueToNameMap[colorValue] ?? "unknown";
  return "Colors.$colorName";
}

Map<String, Color> colorMap = {
  'Colors.red': Colors.red,
  'Colors.blue': Colors.blue,
  'Colors.green': Colors.green,
  'Colors.teal': Colors.teal,
  'Colors.amber': Colors.amber,
  'Colors.brown': Colors.brown,
  'Colors.purple': Colors.purple,
  'Colors.pink': Colors.pink,
  'Colors.blueGrey': Colors.blueGrey,
};
