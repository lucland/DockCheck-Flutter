// BluetoothCubit.dart
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dockcheck/pages/bluetooth/cubit/bluetooth_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;

import '../../../repositories/user_repository.dart';
import '../blue.dart';

class BluetoothCubit extends Cubit<BluetoothState> {
  final UserRepository userRepository;
  final serial.FlutterBluetoothSerial bluetooth =
      serial.FlutterBluetoothSerial.instance;

  BluetoothCubit(this.userRepository) : super(BluetoothStateInitial());

  Future<void> startBluetoothConnection() async {
    emit(BluetoothStateConnecting());

    try {
      List<serial.BluetoothDevice> devices = await bluetooth.getBondedDevices();

      if (devices.isEmpty) {
        throw BluetoothException('No paired devices available');
      }

      // Assuming we want to connect to the first device in the list
      serial.BluetoothDevice selectedDevice = devices[0];

      await connectToDevice(selectedDevice);

      emit(BluetoothStateConnected(devices));
    } catch (e) {
      emit(BluetoothStateError(e.toString()));
    }
  }

  Future<void> connectToDevice(serial.BluetoothDevice device) async {
    try {
      print("connecteddevice");
      // await bluetoothConnectionState();
      await sendMessageToDevice(device, 'Connection established');
    } catch (e) {
      print("errooooooor");
      emit(BluetoothStateError(e.toString()));
    }
  }

  Future<void> bluetoothConnectionState() async {
    List<serial.BluetoothDevice> devices = [];

    try {
      print("connection state");
      devices = await bluetooth.getBondedDevices();

      emit(BluetoothStateConnected(devices));
    } on PlatformException {
      print("errooooooor dddd");
      throw BluetoothException('Error fetching paired devices');
    }

    // emit(BluetoothStateConnected(devices));
  }

  Future<void> sendMessageToDevice(
      serial.BluetoothDevice device, String message) async {
    try {
      var _connection =
          await serial.BluetoothConnection.toAddress(device.address);
      bool mensagemEnviada = false;
      while (!mensagemEnviada) {
        try {
          _connection.output.add(utf8.encode(message));
          await _connection.output.allSent;

          print(
              "Mensagem enviada com sucesso para ${device.address}: $message");
          mensagemEnviada = true;
        } catch (e) {
          print(
              "Erro ao enviar mensagem via Bluetooth para o dispositivo de endereço ${device.address}: $e");
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      print(
          "Erro ao se conectar com o dispositivo de endereço ${device.address}: $e");
    }

    emit(BluetoothChosen(device));
  }
}
