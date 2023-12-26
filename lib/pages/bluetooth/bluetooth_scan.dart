import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_classic/bluetooth_classic_platform_interface.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:dockcheck/pages/bluetooth/bluetooth_connected.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];
  Device? _connectedDevice;
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  bool _connecting = false;
  int _deviceStatus = Device.disconnected;
  Uint8List _data = Uint8List(0);

  late StreamController<int> _deviceStatusController;
  late StreamController<Uint8List> _dataReceivedController;
  late StreamController<Device> _deviceDiscoveredController;

  late StreamSubscription<int> _deviceStatusSubscription;
  late StreamSubscription<Uint8List> _dataReceivedSubscription;
  late StreamSubscription<Device> _deviceDiscoveredSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _deviceStatusController = StreamController<int>.broadcast();
    _dataReceivedController = StreamController<Uint8List>.broadcast();
    _deviceDiscoveredController = StreamController<Device>.broadcast();

    _deviceStatusSubscription = _deviceStatusController.stream.listen((event) {
      setState(() {
        _deviceStatus = event;
      });

      if (_deviceStatus == Device.connected) {
        _connecting = false;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
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

    // Use asBroadcastStream() only once for each stream
    var deviceStatusStream =
        _bluetoothClassicPlugin.onDeviceStatusChanged().asBroadcastStream();
    var dataReceivedStream =
        _bluetoothClassicPlugin.onDeviceDataReceived().asBroadcastStream();
    var deviceDiscoveredStream =
        _bluetoothClassicPlugin.onDeviceDiscovered().asBroadcastStream();

    _deviceStatusSubscription = deviceStatusStream.listen((event) {
      _deviceStatusController.add(event);
    });

    _dataReceivedSubscription = dataReceivedStream.listen((event) {
      _dataReceivedController.add(event);
    });

    _deviceDiscoveredSubscription = deviceDiscoveredStream.listen((event) {
      _deviceDiscoveredController.add(event);
    });
  }

  @override
  void dispose() {
    _deviceStatusSubscription.cancel();
    _dataReceivedSubscription.cancel();
    _deviceDiscoveredSubscription.cancel();

    _deviceStatusController.close();
    _dataReceivedController.close();
    _deviceDiscoveredController.close();

    _bluetoothClassicPlugin.disconnect;
    super.dispose();
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
  }

  Future<void> _getDevices() async {
    var res = await _bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      _devices = res;
    });
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
      await _bluetoothClassicPlugin.startScan();
      setState(() {
        _discoveredDevices = [];
        _scanning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
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
      ),
      floatingActionButton: buildScanButton(context),
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
