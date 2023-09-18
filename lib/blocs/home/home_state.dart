import 'dart:typed_data';

import 'package:cripto_qr_googlemarine/models/user.dart';

class HomeState {
  final Uint8List? pngBytes;
  final String? resultMessage;
  final User? user;
  final bool isLoading;

  HomeState(
      {this.pngBytes, this.resultMessage, this.user, this.isLoading = true});
}
