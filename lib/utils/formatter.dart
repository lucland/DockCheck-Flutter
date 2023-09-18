import 'package:cloud_firestore/cloud_firestore.dart';

class Formatter {
  static String fromTimestamp(Timestamp timestamp) {
    return timestamp
        .toDate()
        .toString()
        .substring(0, 10)
        .split("-")
        .reversed
        .join("/");
  }

  static String identidade(String identidade) {
    String identidadeString = identidade.toString();
    return "${identidadeString.substring(0, 2)}.${identidadeString.substring(2, 5)}.${identidadeString.substring(5, 8)}-${identidadeString.substring(8, 9)}";
  }

  static String formatDateTime(DateTime dateTime) {
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    if (dateTime.day < 10) {
      day = "0" + dateTime.day.toString();
    }
    if (dateTime.month < 10) {
      month = "0" + dateTime.month.toString();
    }
    return day + "/" + month + "/" + year;
  }
}
