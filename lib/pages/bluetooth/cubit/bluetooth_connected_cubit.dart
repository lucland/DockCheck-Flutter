import 'package:bloc/bloc.dart';
import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/pages/bluetooth/cubit/bluetooth_connected_state.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as blue;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;

import '../../../repositories/user_repository.dart';

class BluetoothConnectedCubit extends Cubit<BluetoothConnectedState> {
  final UserRepository userRepository;

  BluetoothConnectedCubit(this.userRepository)
      : super(BluetoothConnectedLoadingState());

  Future<void> getUsers(
      List<blue.ScanResult> list, serial.BluetoothDevice device) async {
    try {
      List<User> users = [];

      for (var device in list) {
        User user = await userRepository.getUserByBeacon(device.device.advName);
        users.add(user);
      }

      emit(BluetoothSuccessState(users, device));
    } catch (e) {
      // Handle the error, you might want to emit an error state here
      print('Error in getUsers: $e');
      emit(BluetoothConnectedErrorState(e
          .toString())); // Rethrow the exception to maintain the error stack trace
    }
  }

  Future<void> setupBluetoothConnection(serial.BluetoothDevice device) async {
    try {
      emit(BluetoothConnectedSuccessState(device));
    } catch (e) {
      emit(BluetoothConnectedErrorState(e.toString()));
    }
  }

  void startBluetoothDiscovery() {
    blue.FlutterBluePlus.startScan();
  }

  Future<void> disconnectBluetooth(serial.BluetoothDevice device) async {
    try {
      // Add your logic to disconnect from the Bluetooth device
      // For example:
      await serial.BluetoothConnection.toAddress(device.address)
          .then((value) => value.close());
      print('testando');
      emit(BluetoothDisconnectedState());
    } catch (e) {
      print('hbuuivbouiboub');
      emit(BluetoothConnectedErrorState(e.toString()));
    }
  }
}
