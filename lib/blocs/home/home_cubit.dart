import 'package:cripto_qr_googlemarine/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository userRepository;
  HomeCubit(
    this.userRepository,
  ) : super(HomeState());

  //fetch last added user
  void fetchLastUser() async {
    try {
      emit(HomeState(isLoading: true));
      User user = await userRepository.fetchLastUser();
      emit(HomeState(user: user, isLoading: false));
    } catch (e) {
      emit(HomeState(resultMessage: e.toString()));
    }
  }

  //final key = encrypt.Key.fromUtf8("1234567890123456");
  // final iv = encrypt.IV.fromUtf8("1234567890123456");
  // final encrypter = encrypt.Encrypter(encrypt.AES(key));
  // final encrypted = encrypter.encrypt(mockUser.toDatabaseString(), iv: iv);

  Future<void> convertWidgetToImage(GlobalKey globalKey, User user) async {
    // ... (the body of your existing convertWidgetToImage method here)

    try {
      // ... (more code here)

      //emit(HomeState(pngBytes: pngBytes, resultMessage: "User Added"));
    } catch (e) {
      emit(HomeState(resultMessage: e.toString()));
    }
  }

//  Future<void> printPngImage(Uint8List pngBytes) async {
  // ... (the body of your existing printPngImage method here)
  // }
}
