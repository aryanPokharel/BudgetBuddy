String getAbbreviatedMonthName(String monthNumber, String yearNumber) {
  switch (monthNumber) {
    case "1":
      return "Jan, $yearNumber";
    case "2":
      return "Feb, $yearNumber";
    case "3":
      return "Mar, $yearNumber";
    case "4":
      return "April, $yearNumber";
    case "5":
      return "May, $yearNumber";
    case "6":
      return "June, $yearNumber";
    case "7":
      return "July, $yearNumber";
    case "8":
      return "Aug, $yearNumber";
    case "9":
      return "Sep, $yearNumber";
    case "10":
      return "Oct, $yearNumber";
    case "11":
      return "Nov, $yearNumber";
    case "12":
      return "Dec, $yearNumber";
    default:
      return "Unknown";
  }
}

String checkTodayYesterday(String inputDate) {
  DateTime currentDate = DateTime.now();
  DateTime currentDateWithoutTime =
      DateTime(currentDate.year, currentDate.month, currentDate.day);
  DateTime parsedDate = DateTime.parse(inputDate);

  if (parsedDate == currentDateWithoutTime) {
    return 'Today';
  } else if (parsedDate ==
      currentDateWithoutTime.subtract(const Duration(days: 1))) {
    return 'Yesterday';
  } else if (parsedDate ==
      currentDateWithoutTime.subtract(const Duration(days: 2))) {
    return 'Day Before';
  } else {
    return inputDate;
  }
}

String getMonthName(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  int month = dateTime.month;
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "Invalid Month";
  }
}
