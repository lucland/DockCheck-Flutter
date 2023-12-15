class Formatter {
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

  static String fromatHourDateTime(DateTime dateTime) {
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString();
    if (dateTime.day < 10) {
      day = "0" + dateTime.day.toString();
    }
    if (dateTime.month < 10) {
      month = "0" + dateTime.month.toString();
    }
    if (dateTime.hour < 10) {
      hour = "0" + dateTime.hour.toString();
    }
    if (dateTime.minute < 10) {
      minute = "0" + dateTime.minute.toString();
    }
    return day + "/" + month + "/" + year + " - " + hour + ":" + minute + "h";
  }
}
