/*import 'package:bloc/bloc.dart';
import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/pages/bluetooth/cubit/bluetooth_connected_state.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as blue;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;

import '../../../repositories/user_repository.dart';

class BluetoothConnectedCubit extends Cubit<BluetoothConnectedState> {
  final UserRepository userRepository;
  final List<blue.ScanResult> detectedDevices = [];

  BluetoothConnectedCubit(this.userRepository)
      : super(BluetoothConnectedLoadingState());

  Future<void> getUsers(
      List<blue.ScanResult> lista, serial.BluetoothDevice dispositivo) async {
    try {
      List<User> usuarios = [];

      // Remove dispositivos que não estão mais visíveis
      detectedDevices.removeWhere(
          (device) => !lista.any((scanResult) => scanResult.device == device));

      for (var dispositivoScan in lista) {
        try {
          if (dispositivoScan.device.name != "" ||
              dispositivoScan.device.name.isNotEmpty) {
            // Verifique se o usuário já está na lista
            if (!usuarios.any(
                (user) => user.iTag == dispositivoScan.device.remoteId.str)) {
              User usuario = await userRepository
                  .getUserByBeacon(dispositivoScan.device.remoteId.str);
              usuarios.add(usuario);
            }
          }
        } catch (e) {
          //não interrompa o loop
          print('Erro ao obter usuário para o dispositivo: $e');
        }
      }

      emit(BluetoothSuccessState(usuarios, dispositivo));
    } catch (e) {
      // outros erros inesperados
      print('Erro em getUsers');
      emit(BluetoothConnectedErrorState(e.toString()));
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
*/