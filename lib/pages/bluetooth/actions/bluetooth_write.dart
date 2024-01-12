/*import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class bluetoothSend {
  BluetoothConnection? _connection;

  void setConnection(BluetoothConnection connection) {
    _connection = connection;
  }

  Future<void> sendMessageToDevice(String deviceAddress, String message) async {
    try {
      if (_connection == null || !_connection!.isConnected) {
        _connection = await BluetoothConnection.toAddress(deviceAddress);
      }

      bool mensagemEnviada = false;
      while (!mensagemEnviada) {
        try {
          if (_connection!.isConnected) {
            _connection!.output.add(utf8.encode(message));
            await _connection!.output.allSent;

            print("Mensagem enviada com sucesso para $deviceAddress: $message");
            mensagemEnviada = true;
          } else {
            print(
                "Não foi possível se conectar com o dispositivo de endereço $deviceAddress");
          }
        } catch (e) {
          print(
              "Erro ao enviar mensagem via Bluetooth para o dispositivo de endereço $deviceAddress: $e");
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      print(
          "Erro ao se conectar com o dispositivo de endereço $deviceAddress: $e");
    }
  }
}
*/