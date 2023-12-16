import 'package:flutter/material.dart';

dynamic defaultAppTheme = Colors.green;

dynamic months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

List<Color> appThemeColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.teal,
  Colors.amber,
  Colors.brown,
  Colors.purple,
  Colors.pink,
];

Map<String, String> currencyMap = {
  'NRS': "₹",
  'USD': "\$",
  'INR': "₹",
};

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  // : Colors.teal,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    // Add more text styles as needed
  ),
);

// Define a list of potential field names
List<String> amountFieldNames = [
  'total_amount',
  'total',
  'net_total',
  'sub_total',
  'sub total',
  'amount',
];
List<String> titleFieldNames = [
  'title',
  'client',
  'client_name',
  'customer',
  'customer_name',
];
List<String> dateFieldNames = [
  'date',
  'Date',
];
