import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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

class ChatPage extends StatefulWidget {
  final serial.BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  serial.BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    print('Iniciando initState');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<BluetoothConnectedCubit>()
          .setupBluetoothConnection(widget.server);
      context.read<BluetoothConnectedCubit>().startBluetoothDiscovery();
    });

    serial.BluetoothConnection.toAddress(widget.server.address)
        .then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Construindo widget');

    return _build(widget.server);
  }

  Widget _build(serial.BluetoothDevice device) {
    print('Construindo _build');

    final serverName = widget.server.name ?? "Unknown";
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
                        initialData: const [],
                        builder: (context, snapshot) {
                          final List<blue.ScanResult> scanResults =
                              snapshot.data!;
                          context
                              .read<BluetoothConnectedCubit>()
                              .getUsers(scanResults, device);

                          return BlocConsumer<BluetoothConnectedCubit,
                              BluetoothConnectedState>(
                            listener: (context, state) {
                              if (state is BluetoothDisconnectedState) {
                                return Navigator.of(context).pop();
                              } else if (state
                                  is BluetoothConnectedErrorState) {
                                return Navigator.of(context).pop();
                              }
                            },
                            builder: (context, state) {
                              if (state is BluetoothConnectedLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is BluetoothSuccessState) {
                                return state.usuarios.isNotEmpty
                                    ? GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 0.0,
                                          mainAxisSpacing: 0.0,
                                        ),
                                        itemCount: state.usuarios.length,
                                        itemBuilder: (context, index) {
                                          state.usuarios.sort((a, b) =>
                                              a.number.compareTo(b.number));

                                          bool isRed =
                                              state.usuarios[index].isBlocked;

                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ListTile(
                                              tileColor: isRed
                                                  ? CQColors.danger100
                                                  : CQColors.success100,
                                              subtitle: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.04,
                                                    ),
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: state
                                                                    .usuarios[
                                                                        index]
                                                                    .number
                                                                    .toString(),
                                                                style: CQTheme
                                                                    .h3
                                                                    .copyWith(
                                                                  color: CQColors
                                                                      .white,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: state
                                                                .usuarios[index]
                                                                .name
                                                                .toString(),
                                                            style: CQTheme.body
                                                                .copyWith(
                                                              color: CQColors
                                                                  .white,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                if (isRed) {
                                                  _showRedPopup(
                                                    context,
                                                    state.usuarios[index].name,
                                                    state.usuarios[index].id,
                                                    state.usuarios[index].iTag,
                                                    state.usuarios[index].cpf,
                                                  );
                                                } else {
                                                  _showGreenPopup(
                                                    context,
                                                    state.usuarios[index].name,
                                                    state.usuarios[index].id,
                                                    state.usuarios[index].iTag,
                                                    state.usuarios[index].cpf,
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : const Text("sem usuario");
                              } else {
                                return Container(
                                  color: Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //_showDeviceInfo(context, device);
                      },
                      child: (isConnecting
                          ? Text(
                              'conectando-se com o portaló',
                              style: const TextStyle(
                                color: CQColors.iron100,
                                fontSize: 24,
                              ),
                            )
                          : isConnected
                              ? Text(
                                  'Comunicando com o portaló',
                                  style: const TextStyle(
                                    color: CQColors.iron100,
                                    fontSize: 24,
                                  ),
                                )
                              : Text(
                                  'erro portaló',
                                  style: const TextStyle(
                                    color: CQColors.iron100,
                                    fontSize: 24,
                                  ),
                                )),
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      color: Colors.amber,
                    )
                  ],
                ),
              ),
            ),
            _buildBluetoothChat(),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothChat() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: messages.isNotEmpty
                ? ListView.builder(
                    controller: listScrollController,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _Message message = messages[index];
                      return ListTile(
                        title: Text(message.text),
                      );
                    },
                  )
                : const Center(
                    child: Text("Sem mensagens"),
                  ),
          ),
        ],
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      String receivedMessage = backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString.substring(0, index);

      setState(() {
        messages.add(
          _Message(
            1,
            receivedMessage,
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    print('Enviando mensagem: $text');

    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        await Future.delayed(Duration(milliseconds: 333));

        await listScrollController.animateTo(
            listScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 333),
            curve: Curves.easeOut);
      } catch (e) {
        print('Erro ao enviar mensagem: $e');
      }
    }
  }

  void _showGreenPopup(BuildContext context, String userName, String userId,
      String beaconSerial, String userCpf) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Container(
                    color: CQColors.success100,
                    padding: const EdgeInsets.all(16.0),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(text: userName),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'CANCELAR',
                            style: CQTheme.h3.copyWith(color: CQColors.iron100),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          _sendMessage(
                              'P1 SDATA'); // liberado verde 'P1 T,$beaconSerial,F1 TTL'
                          // $beaconSerial - id do beacon relacionado
                          //$userId - nome da pessoa relacionado ao beacon
                          //$userCpf - cpf da pessoa relacionado ao beacon

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Mensagem de liberacao enviada para o portaló",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: CQColors.iron100,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
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

  void _showRedPopup(BuildContext context, String userName, String userId,
      String beaconSerial, String userCpf) async {
    final TextEditingController userReason = TextEditingController();
    bool isLiberarButtonEnabled = false; // Adicionando a flag
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(16.0),
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$userName não liberado,',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          child: Flexible(
                            flex: 1,
                            child: TextInputWidget(
                              onChanged: (value) {
                                setState(() {
                                  isLiberarButtonEnabled = value.isNotEmpty;
                                });
                              },
                              isRequired: false,
                              controller: userReason,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'OK',
                            style: CQTheme.h3.copyWith(color: CQColors.iron100),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isLiberarButtonEnabled) {
                            _sendMessage(''); // passei o texto do textfield
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Colors.grey),
                            color: isLiberarButtonEnabled
                                ? Colors.black
                                : Colors.grey,
                          ),
                          padding: const EdgeInsets.symmetric(
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
