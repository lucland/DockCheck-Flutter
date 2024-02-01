/*import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class bluetoohOffScreen extends StatefulWidget {
  const bluetoohOffScreen({super.key});

  @override
  State<bluetoohOffScreen> createState() => _bluetoohOffScreenState();
}

class _bluetoohOffScreenState extends State<bluetoohOffScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bluetooth_disabled,
                size: 200,
                color: CQColors.danger100,
              ),
              GestureDetector(
                onTap: () async {
                  await FlutterBluetoothSerial.instance.requestEnable();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: CQColors.iron100),
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4),
                    child: Text(
                      'ligar bluetooth',
                      style: CQTheme.body,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/