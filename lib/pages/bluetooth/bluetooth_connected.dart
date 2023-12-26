import 'dart:io';

import 'package:dockcheck/pages/cadastrar/cadastrar.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic_platform_interface.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BluetoothConnectedScreen extends StatefulWidget {
  final Device?
      connectedDevice; // Adicionado para receber o dispositivo conectado

  const BluetoothConnectedScreen({Key? key, this.connectedDevice})
      : super(key: key);

  @override
  State<BluetoothConnectedScreen> createState() =>
      _BluetoothConnectedScreenState(connectedDevice);
}

class _BluetoothConnectedScreenState extends State<BluetoothConnectedScreen> {
  final _bluetoothClassicPlugin = BluetoothClassic();
  Device? _connectedDevice;

  _BluetoothConnectedScreenState(Device? connectedDevice) {
    _connectedDevice = connectedDevice;
  }

  Widget buildConnectedPage(BuildContext context) {
    return Column(
      children: [
        Text(
          '${_connectedDevice?.name ?? _connectedDevice?.address ?? 'Desconhecido'} conectado',
          style: TextStyle(
            color: CQColors.iron100,
            fontSize: 40,
          ),
        ),
        Text(
          'e recebendo dados',
          style: TextStyle(
            color: CQColors.iron100,
            fontSize: 40,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
              child: GestureDetector(
                onTap: () async {
                  await _bluetoothClassicPlugin.disconnect();
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CQColors.iron100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 40,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Desconectar',
                        style: CQTheme.h3.copyWith(
                          color: CQColors.iron20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                BluetoothClassicPlatform.instance
                    .write(' conexão estabelecida ');
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CQColors.iron100,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 40,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Cadastrar e enviar',
                      style: CQTheme.h3.copyWith(
                        color: CQColors.iron20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: CQColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (Platform.isAndroid) buildConnectedPage(context),
            ],
          ),
        ),
      ),
    );
  }
}
