import 'package:intl/intl.dart';

convertTime(transactionList) {
  DateTime transactionDate = DateTime.parse(transactionList);
  String formattedTime = DateFormat('h:mm a').format(transactionDate);

  return formattedTime;
}
