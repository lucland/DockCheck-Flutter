import 'package:dockcheck/pages/bluetooth/bluetooth_connected.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;
import 'package:provider/provider.dart';

import 'cubit/bluetooth_cubit.dart';
import 'cubit/bluetooth_state.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.red,
              ),
              const Text(
                'Seu bluetooth está desligado',
                style: CQTheme.h2,
              ),
              const SizedBox(
                height: 4,
              ),
              GestureDetector(
                onTap: () {
                  serial.FlutterBluetoothSerial.instance.requestEnable();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: CQColors.white,
                        border: Border.all(
                          color: CQColors.iron100,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Ligar bluetooth',
                        style: CQTheme.bodyIron100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BluetoothCubit, BluetoothState>(
      listener: (context, state) {
        if (state is BluetoothChosen) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BluetoothConnectedScreen(
              device: state.device,
            ),
          ));
        }
      },
      builder: (context, state) {
        if (state is BluetoothStateInitial) {
          context.read<BluetoothCubit>().bluetoothConnectionState();
        }
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                RefreshIndicator(
                  color: CQColors.iron100,
                  onRefresh: () async {
                    context.read<BluetoothCubit>().bluetoothConnectionState();
                  },
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Se o seu dispositivo não estiver na lista, "
                              "conecte-se manualmente pelas configurações do seu aparelho.",
                              textAlign: TextAlign.center,
                              style: CQTheme.bodyGrey
                                  .copyWith(color: CQColors.iron60),
                            ),
                          ),
                          Column(
                            children: _buildDevicesList(context, state),
                          ),
                          GestureDetector(
                            onTap: () async {
                              context
                                  .read<BluetoothCubit>()
                                  .startBluetoothConnection();
                            },
                            child: Container(
                              color: Colors.amber,
                              width: 100,
                              height: 40,
                              child: Center(
                                child: Text(
                                  'Conectar',
                                  style: CQTheme.body.copyWith(
                                    color: CQColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (state is BluetoothStateConnecting)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Color.fromARGB(255, 102, 195, 112),
                      padding: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 8),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                CQColors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Conectando-se ao dispositivo...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (state is BluetoothStateError)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Color.fromARGB(255, 195, 102, 102),
                      padding: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 12),
                            Text(
                              'Erro ao tentar se conectar ao dispositivo',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDevicesList(BuildContext context, BluetoothState state) {
    if (state is BluetoothStateConnected) {
      return state.devices
          .map(
            (e) => ListTile(
              title: Text(e.name ?? "Desconhecido"),
              subtitle: Text(e.address),
              trailing: GestureDetector(
                onTap: () {
                  if (e.isConnected) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BluetoothConnectedScreen(
                        device: e,
                      ),
                    ));
                  } else {
                    context
                        .read<BluetoothCubit>()
                        .sendMessageToDevice(e, 'conectado');
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color:
                        e.isConnected ? CQColors.iron100 : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CQColors.iron100,
                      width: 1,
                    ),
                  ),
                  child: e.isConnected
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'abrir',
                            style: CQTheme.body.copyWith(color: CQColors.white),
                          ),
                        )
                      : Text(
                          "conectar",
                          style: CQTheme.body.copyWith(color: CQColors.iron100),
                        ),
                ),
              ),
            ),
          )
          .toList();
    } else {
      return [];
    }
  }
}

class BluetoothException implements Exception {
  final String message;

  BluetoothException(this.message);
}
