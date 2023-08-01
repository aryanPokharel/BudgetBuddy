import 'package:intl/intl.dart';

// Function to format DateTime to a custom date string
String formatDate(DateTime dateTime) {
  // Replace 'yyyy-MM-dd' with your desired date format
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

// Usage example
void main() {
  DateTime dateTime = DateTime.now();
  String formattedDate = formatDate(dateTime);
  print(formattedDate); // Output: e.g., '2023-08-02'
}
