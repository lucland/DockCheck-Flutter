// bluetooth_connected_screen.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/pages/bluetooth/cubit/bluetooth_connected_cubit.dart';
import 'package:dockcheck/pages/bluetooth/cubit/bluetooth_connected_state.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as blue;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as serial;

class BluetoothConnectedScreen extends StatelessWidget {
  const BluetoothConnectedScreen({
    Key? key,
    required this.device,
  }) : super(key: key);

  final serial.BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return BluetoothConnectedScreenContent(device: device);
  }
}

class BluetoothConnectedScreenContent extends StatefulWidget {
  final serial.BluetoothDevice device;

  const BluetoothConnectedScreenContent({Key? key, required this.device})
      : super(key: key);

  @override
  _BluetoothConnectedScreenContentState createState() =>
      _BluetoothConnectedScreenContentState(device: device);
}

class _BluetoothConnectedScreenContentState
    extends State<BluetoothConnectedScreenContent> {
  final serial.BluetoothDevice device;

  _BluetoothConnectedScreenContentState({required this.device});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _context = context;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Move the setupBluetoothConnection and startBluetoothDiscovery
      // calls to the end of the frame to avoid issues during dispose.
      context.read<BluetoothConnectedCubit>().setupBluetoothConnection(device);
      context.read<BluetoothConnectedCubit>().startBluetoothDiscovery();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Use context directly instead of _context
      if (mounted) {
        context.read<BluetoothConnectedCubit>().disconnectBluetooth(device);
        context.read<BluetoothConnectedCubit>().close();
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BluetoothConnectedCubit, BluetoothConnectedState>(
      listener: (context, state) {
        if (state is BluetoothDisconnectedState) {
          return Navigator.of(context).pop();
        } else if (state is BluetoothConnectedErrorState) {
          return Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is BluetoothConnectedLoadingState) {
          return Center(
            child: Container(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is BluetoothConnectedSuccessState) {
          return _buildSuccessUI(state.device);
        } else if (state is BluetoothSuccessState) {
          return _buildSuccessUI(state.device);
        } else {
          return Container(); // Handle other states if needed
        }
      },
    );
  }

  Widget _buildSuccessUI(serial.BluetoothDevice device) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        context.read<BluetoothConnectedCubit>().startBluetoothDiscovery();
      },
      child: Material(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<List<blue.ScanResult>>(
                        stream: blue.FlutterBluePlus.scanResults,
                        initialData: [],
                        builder: (context, snapshot) {
                          final List<blue.ScanResult> scanResults =
                              snapshot.data!;
                          context
                              .read<BluetoothConnectedCubit>()
                              .getUsers(scanResults, device);

                          return BlocConsumer<BluetoothConnectedCubit,
                              BluetoothConnectedState>(
                            listener: (context, state) {
                              // Add any necessary listeners if needed
                            },
                            builder: (context, state) {
                              if (state is BluetoothConnectedLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is BluetoothSuccessState) {
                                return state.usuarios.length >= 1
                                    ? GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 0.0,
                                          mainAxisSpacing: 0.0,
                                        ),
                                        itemCount: state.usuarios.length,
                                        itemBuilder: (context, index) {
                                          bool isRed = index % 2 == 0;

                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ListTile(
                                              tileColor: isRed
                                                  ? CQColors.danger100
                                                  : CQColors.success100,
                                              subtitle: Center(
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: state
                                                            .usuarios[index]
                                                            .name,
                                                        style:
                                                            CQTheme.h1.copyWith(
                                                          color: CQColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                    style: CQTheme.h3.copyWith(
                                                        color:
                                                            CQColors.iron100),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                if (isRed) {
                                                  // Handle onTap for red tiles
                                                } else {
                                                  // Handle onTap for green tiles
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : Text("sem usuario");
                              } else {
                                return Container(
                                  color: Colors.pink,
                                );
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: CQColors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDeviceInfo(context, device);
                      },
                      child: Text(
                        '${device.name ?? 'Unknown'} connected',
                        style: TextStyle(
                          color: CQColors.iron100,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: CQColors.iron100,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 40,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeviceInfo(BuildContext context, serial.BluetoothDevice device) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Device Information'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${device.name}'),
              Text('Address: ${device.address}'),
              // Add more information as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _sendMessageViaBluetooth(
    serial.BluetoothConnection connection,
    String message,
  ) async {
    if (connection != null && connection.isConnected) {
      connection.output.add(Uint8List.fromList(utf8.encode(message)));
      await connection.output.allSent;
    } else {
      print("No active Bluetooth connection");
    }
  }

  void _showGreenPopup(BuildContext context, blue.ScanResult scanResult) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: CQColors.success100,
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LIBERAR',
                        style: CQTheme.h3.copyWith(color: CQColors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${scanResult.device.id.toString().substring(scanResult.device.id.toString().length - 2)}',
                        ),
                      ],
                      style: CQTheme.h3
                          .copyWith(color: CQColors.iron100, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 64.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'CANCELAR',
                            style: CQTheme.h3.copyWith(color: CQColors.iron100),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          //serial.BluetoothDevice selectedDevice = devicesList[0];

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Message sent to the connected Bluetooth device"),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: CQColors.iron100,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 64.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'OK, LIBERAR',
                            style: CQTheme.h3.copyWith(color: CQColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRedPopup(BuildContext context, blue.ScanResult scanResult) {
    final TextEditingController userNumber = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.red, // Change to your desired color
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BLOQUEADO',
                        style: CQTheme.h3.copyWith(color: CQColors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usuário ${scanResult.device.id.toString().substring(scanResult.device.id.toString().length - 2)} não liberado,',
                          style: CQTheme.h3
                              .copyWith(color: CQColors.iron100, fontSize: 16),
                        ),
                        Text(
                          'por favor, comparecer',
                          style: CQTheme.h3
                              .copyWith(color: CQColors.iron100, fontSize: 16),
                        ),
                        Text(
                          'a cabine de cadastro',
                          style: CQTheme.h3
                              .copyWith(color: CQColors.iron100, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          child: Flexible(
                            flex: 1,
                            child: TextInputWidget(
                              onChanged: (value) {},
                              isRequired: false,
                              controller: userNumber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await blue.FlutterBluePlus.stopScan();
                          blue.FlutterBluePlus.startScan();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 64.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'OK',
                            style: CQTheme.h3.copyWith(color: CQColors.iron100),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Implement the method for release with the database
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Colors.grey),
                            color: userNumber.text.isNotEmpty
                                ? Colors.white
                                : Colors.grey,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 60.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'LIBERAR',
                            style: CQTheme.h3.copyWith(color: CQColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
