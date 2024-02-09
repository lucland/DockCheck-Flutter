import 'dart:typed_data';

import 'package:dockcheck/models/user.dart';

import '../../../models/vessel.dart';

class HomeState {
  final Uint8List? pngBytes;
  final String? resultMessage;
  final User? loggedUser;
  final bool isLoading;
  final List<Vessel> vessels;
  final List<User> onboardUsers;
  final List<User> blockedUsers;
  final String? error;
  final bool invalidToken;
  final bool showAllUsers;

  HomeState({
    this.pngBytes,
    this.resultMessage,
    this.loggedUser,
    this.isLoading = true,
    this.vessels = const [],
    this.onboardUsers = const [],
    this.blockedUsers = const [],
    this.error,
    this.invalidToken = false,
    this.showAllUsers = false,
  });

  HomeState copyWith({
    Uint8List? pngBytes,
    String? resultMessage,
    User? loggedUser,
    bool? isLoading,
    List<Vessel>? vessels,
    List<User>? onboardUsers,
    List<User>? blockedUsers,
    String? error,
    bool? invalidToken,
    bool? isTicketListVisible,
  }) {
    return HomeState(
      pngBytes: pngBytes ?? this.pngBytes,
      resultMessage: resultMessage ?? this.resultMessage,
      loggedUser: loggedUser ?? this.loggedUser,
      isLoading: isLoading ?? this.isLoading,
      vessels: vessels ?? this.vessels,
      onboardUsers: onboardUsers ?? this.onboardUsers,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      error: error ?? this.error,
      invalidToken: invalidToken ?? this.invalidToken,
      showAllUsers: showAllUsers ?? this.showAllUsers,
    );
  }
}
