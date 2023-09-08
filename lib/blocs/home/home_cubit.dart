import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

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
