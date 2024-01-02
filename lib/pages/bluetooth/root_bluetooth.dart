import 'package:dockcheck/pages/bluetooth/blue.dart';
import 'package:dockcheck/pages/bluetooth/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class bluetoothSearch extends StatelessWidget {
  const bluetoothSearch({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bluetooth',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: const IntegratedBluetoothScreen(),
        ));
  }
}

class IntegratedBluetoothScreen extends StatefulWidget {
  const IntegratedBluetoothScreen({super.key});

  @override
  State<IntegratedBluetoothScreen> createState() =>
      _IntegratedBluetoothScreenState();
}

class _IntegratedBluetoothScreenState extends State<IntegratedBluetoothScreen> {
  BluetoothState _bState = BluetoothState.UNKNOWN;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.onStateChanged().listen((event) {
      setState(() {
        _bState = event;
      });
    });
    checkConnected();
  }

  void checkConnected() async {
    if (await FlutterBluetoothSerial.instance.isEnabled == true) {
      setState(() {
        _bState = BluetoothState.STATE_ON;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bState == BluetoothState.STATE_ON) {
      return const FindDevicesScreen();
    }
    return const BluetoothOffScreen();
  }
}
