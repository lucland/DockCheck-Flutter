import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_classic/bluetooth_classic_platform_interface.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:dockcheck/pages/bluetooth/widgets/streams.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'device_screen.dart'; // Certifique-se de importar o DeviceScreen
import '../../utils/simple_logger.dart';
import 'widgets/scan_result_title.dart';
import 'widgets/system_device_title.dart'; // Importe seus utilitários

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String _platformVersion = 'Unknown';
  final _bluetoothClassicPlugin = BluetoothClassic();
  bool _scanning = false;
  bool _isConnected = false;
  Uint8List _data = Uint8List(0);
  late StreamSubscription<bool> _scanningSubscription;
  late StreamSubscription<Device> _deviceDiscoveredSubscription;
  int _deviceStatus = Device.disconnected;
  List<Device> _discoveredDevices = [];
  List<Device> _devices = [];

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    initPlatformState();
    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      setState(() {
        _deviceStatus = event;
        _isConnected = _deviceStatus == Device.connected;
      });
    });
    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      setState(() {
        _data = Uint8List.fromList([..._data, ...event]);
      });
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _bluetoothClassicPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      _devices = res;
    });
  }

  Future<void> _scan() async {
    if (_scanning) {
      await _bluetoothClassicPlugin.stopScan();
      setState(() {
        _scanning = false;
      });
    } else {
      await _bluetoothClassicPlugin.startScan();
      _deviceDiscoveredSubscription =
          _bluetoothClassicPlugin.onDeviceDiscovered().listen(
        (event) {
          setState(() {
            _discoveredDevices = [..._discoveredDevices, event];
          });
        },
      );
      setState(() {
        _scanning = true;
      });
    }
  }

  @override
  void dispose() {
    _scanningSubscription.cancel();
    _deviceDiscoveredSubscription.cancel();
    super.dispose();
  }

  Future<void> onScanPressed() async {
    try {
      if (!_scanning) {
        print("Iniciando escaneamento...");
        await _bluetoothClassicPlugin.startScan();
        setState(() {
          _scanning = true;
        });
      } else {
        print("Parando escaneamento...");
        await _bluetoothClassicPlugin.stopScan();
        _deviceDiscoveredSubscription.cancel();
        setState(() {
          _scanning = false;
        });
      }
    } catch (e) {
      SimpleLogger.warning('Error during scan operation: $e');
    }
  }

  Future<void> onStopPressed() async {
    try {
      await BluetoothClassicPlatform.instance.stopScan();
      _deviceDiscoveredSubscription.cancel();
      setState(() {
        _scanning = false;
      });
    } catch (e) {
      SimpleLogger.warning('Error during stopScan: $e');
    }
  }

  Future<void> onRefresh() async {
    if (_scanning == false) {
      await BluetoothClassicPlatform.instance.startScan();
    }
    setState(() {});
    return Future.delayed(const Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (_scanning) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: CQColors.danger100,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
        backgroundColor: CQColors.iron100,
        onPressed: onScanPressed,
        child: Icon(Icons.sensors_rounded, size: 30, color: CQColors.white),
      );
    }
  }

  Widget buildDeviceList() {
    if (_scanning) {
      return const Text("Procurando dispositivos...");
    } else if (_discoveredDevices.isEmpty) {
      return const Text("Nenhum dispositivo encontrado.");
    } else {
      return Column(
        children: [
          Text("Dispositivos disponíveis:"),
          for (var device in _discoveredDevices)
            ListTile(
              title: Text(device.name ?? device.address),
              subtitle: Text(device.address),
              onTap: () async {
                await _bluetoothClassicPlugin.connect(
                  device.address,
                  "00001101-0000-1000-8000-00805f9b34fb",
                );
                setState(() {
                  _discoveredDevices = [];
                  _devices = [];
                });
              },
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            buildDeviceList(),
          ],
        ),
      ),
      floatingActionButton: buildScanButton(context),
    );
  }
}
