import 'package:intl/intl.dart';

// Function to format DateTime to a custom date string
String formatDate(DateTime dateTime) {
  // Replace 'yyyy-MM-dd' with your desired date format
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

DateTime stringToDate(String dateString) {
  // Replace 'yyyy-MM-dd' with your desired date format
  DateFormat format = DateFormat('yyyy-MM-dd');
  DateTime dateTime = format.parse(dateString);
  return dateTime;
}
