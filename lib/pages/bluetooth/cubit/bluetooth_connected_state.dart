import 'package:bloc/bloc.dart';
import 'package:dockcheck/models/user.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as blue;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;

abstract class BluetoothConnectedState {}

class BluetoothConnectedLoadingState extends BluetoothConnectedState {}

class BluetoothDisconnectedState extends BluetoothConnectedState {}

class BluetoothConnectedSuccessState extends BluetoothConnectedState {
  final serial.BluetoothDevice device;

  BluetoothConnectedSuccessState(this.device);
}

class BluetoothSuccessState extends BluetoothConnectedState {
  final List<User> usuarios;
  final serial.BluetoothDevice device;

  BluetoothSuccessState(this.usuarios, this.device);
}

class BluetoothConnectedErrorState extends BluetoothConnectedState {
  final String errorMessage;

  BluetoothConnectedErrorState(this.errorMessage);
}
