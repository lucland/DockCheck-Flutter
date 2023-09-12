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

  static String identidade(int identidade) {
    String identidadeString = identidade.toString();
    return "${identidadeString.substring(0, 2)}.${identidadeString.substring(2, 5)}.${identidadeString.substring(5, 8)}-${identidadeString.substring(8, 9)}";
  }
}
