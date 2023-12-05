import 'dart:typed_data';

import 'package:cripto_qr_googlemarine/models/user.dart';

import '../../../models/vessel.dart';

class HomeState {
  final Uint8List? pngBytes;
  final String? resultMessage;
  final User? loggedUser;
  final bool isLoading;
  List<Vessel> vessels;
  List<User> onboardUsers = [];

  HomeState({
    this.pngBytes,
    this.resultMessage,
    this.loggedUser,
    this.isLoading = true,
    this.vessels = const [],
    this.onboardUsers = const [],
  });
}
