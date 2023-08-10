import 'package:flutter/material.dart';

IconData parseIconData(String iconDataString) {
  int codePoint = int.parse(iconDataString, radix: 16);
  return IconData(codePoint, fontFamily: 'MaterialIcons');
}

IconData getReadableIconData(String iconDataString) {
  // Strip off the first two characters of the icon data string
  String strippedIconDataString = iconDataString.substring(2);
  return parseIconData(strippedIconDataString);
}
