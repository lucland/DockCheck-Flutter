import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class BluetoothState {}

class BluetoothStateInitial extends BluetoothState {}

class BluetoothStateConnecting extends BluetoothState {}

class BluetoothChosen extends BluetoothState {
  final BluetoothDevice device;

  BluetoothChosen(this.device);
}

class BluetoothStateConnected extends BluetoothState {
  List<BluetoothDevice> devices = [];

  BluetoothStateConnected(this.devices);
}

class BluetoothStateError extends BluetoothState {
  final String errorMessage;

  BluetoothStateError(this.errorMessage);
}
