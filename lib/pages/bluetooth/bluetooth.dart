import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'package:dockcheck/pages/bluetooth/bluetooth_connected.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
// Import other necessary packages

class IntegratedBluetoothScreen extends StatefulWidget {
  @override
  _IntegratedBluetoothScreenState createState() =>
      _IntegratedBluetoothScreenState();
}

class _IntegratedBluetoothScreenState extends State<IntegratedBluetoothScreen> {
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  Device? _connectedDevice;
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  bool _connecting = false;
  int _deviceStatus = Device.disconnected;
  Uint8List _data = Uint8List(0);

  late StreamSubscription<int> _deviceStatusSubscription;
  late StreamSubscription<Uint8List> _dataReceivedSubscription;
  late StreamSubscription<Device> _deviceDiscoveredSubscription;

  late StreamController<int> _deviceStatusController;
  late StreamController<Uint8List> _dataReceivedController;
  late StreamController<Device> _deviceDiscoveredController;

  @override
  void initState() {
    super.initState();
    _setupBluetoothClassicListeners();
  }

  void _setupBluetoothClassicListeners() {
    // Initializing StreamControllers for broadcasting
    _deviceStatusController = StreamController<int>.broadcast();
    _dataReceivedController = StreamController<Uint8List>.broadcast();
    _deviceDiscoveredController = StreamController<Device>.broadcast();

    // Subscribing to the StreamControllers
    _deviceStatusSubscription = _deviceStatusController.stream.listen((event) {
      setState(() {
        _deviceStatus = event;
        if (event == Device.connected) {
          _connecting = false;
        }
      });
    });

    _dataReceivedSubscription = _dataReceivedController.stream.listen((event) {
      setState(() {
        _data = Uint8List.fromList([..._data, ...event]);
      });
    });

    _deviceDiscoveredSubscription =
        _deviceDiscoveredController.stream.listen((event) {
      setState(() {
        _discoveredDevices = [..._discoveredDevices, event];
      });
    });

    print(_deviceStatusController.hasListener);
    print(_deviceStatusController.isPaused);
    print(_deviceStatusController.isClosed);
  }

  void _bluetoothDiscovery() {
    // Linking StreamControllers to the BluetoothClassic plugin streams

    _deviceStatusSubscription = _bluetoothClassicPlugin
        .onDeviceStatusChanged()
        .asBroadcastStream()
        .listen((event) {
      _deviceStatusController.add(event);
    });

    _dataReceivedSubscription = _bluetoothClassicPlugin
        .onDeviceDataReceived()
        .asBroadcastStream()
        .listen((event) {
      _dataReceivedController.add(event);
    });

    _deviceDiscoveredSubscription = _bluetoothClassicPlugin
        .onDeviceDiscovered()
        .asBroadcastStream()
        .listen((event) {
      _deviceDiscoveredController.add(event);
    });
  }

  @override
  void dispose() {
    _deviceStatusSubscription.cancel();
    _dataReceivedSubscription.cancel();
    _deviceDiscoveredSubscription.cancel();

    _dataReceivedController.close();
    _deviceStatusController.close();
    _deviceDiscoveredController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScanUI();
  }

  Widget _buildScanUI() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ..._discoveredDevices
                .map(
                  (device) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          device.name ?? device.address,
                          style: TextStyle(fontSize: 20),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _connecting = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: CQColors.success90,
                                content: Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      CircularProgressIndicator(
                                        color: CQColors.white,
                                      ),
                                      SizedBox(width: 16),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Conectando-se ao dispositivo',
                                          style: TextStyle(
                                            color: CQColors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                duration: Duration(seconds: 10),
                              ),
                            );

                            await _bluetoothClassicPlugin.connect(
                              device.address,
                              "00001101-0000-1000-8000-00805f9b34fb",
                            );
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        BluetoothConnectedScreen(
                                  connectedDevice: device,
                                ),
                              ),
                            );
                            setState(() {
                              _connectedDevice = device;
                              _discoveredDevices = [];
                              _devices = [];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: CQColors.iron100,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "Conectar",
                              style: CQTheme.body
                                  .copyWith(color: CQColors.iron100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            SizedBox(height: 16),
            Text(
              " ${String.fromCharCodes(_data)}",
              style: CQTheme.h1.copyWith(),
            ),
          ],
        ),
      ),
      floatingActionButton: buildScanButton(context),
    );
  }

  Future<void> _scan() async {
    if (_connecting) {
      return;
    }

    if (_scanning) {
      await _bluetoothClassicPlugin.stopScan();
      setState(() {
        _scanning = false;
      });
    } else {
      _bluetoothDiscovery();
      await _bluetoothClassicPlugin.startScan();
      setState(() {
        _discoveredDevices = [];
        _scanning = true;
      });
    }
  }

  Widget _buildBluetoothOffUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bluetooth_disabled, size: 200.0, color: Colors.red),
            Text('Bluetooth is off', style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                if (Platform.isAndroid) {}
              },
              child: Text('Turn On Bluetooth'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultUI() {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildScanButton(BuildContext context) {
    if (_scanning) {
      return FloatingActionButton(
        onPressed: () {
          _bluetoothClassicPlugin.disconnect;
          _scan();
        },
        backgroundColor: CQColors.danger100,
        child: const Icon(Icons.stop, color: CQColors.iron100),
      );
    } else {
      return FloatingActionButton(
        backgroundColor: CQColors.iron100,
        onPressed: () {
          _scan();
        },
        child: Icon(Icons.sensors_rounded, size: 30, color: CQColors.white),
      );
    }
  }
}
