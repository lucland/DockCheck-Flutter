/*import 'dart:async';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/widgets/dbloc.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const DropDown({Key? key, required this.controller, this.onChanged})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? selectedDevice;
  late StreamSubscription<List<blue.ScanResult>> scanSubscription;
  List<blue.ScanResult> scanResults = [];
  int maxDistance = -50;
  late Timer scanTimer;
  late DeviceCubit deviceCubit;

  @override
  void initState() {
    super.initState();
    deviceCubit = DeviceCubit();
    startScan();

    scanTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      stopScan();
      startScan();
      Timer(Duration(seconds: 5), () {
        stopScan();
      });
    });
  }

  void startScan() {
    scanSubscription = blue.FlutterBluePlus.scanResults.listen(
      (List<blue.ScanResult> results) {
        setState(() {
          results = results
              .where((result) =>
                  result.device.name?.toLowerCase().startsWith('itag') ==
                      true &&
                  result.rssi > maxDistance)
              .toList();

          results.sort((a, b) => b.rssi.compareTo(a.rssi));
          scanResults = results.take(1).toList();

          if (scanResults.isNotEmpty) {
            widget.controller.text = scanResults[0].device.id.toString();
            widget.onChanged?.call(widget.controller.text);

            // Atualizar o estado do Cubit
            deviceCubit.updateDeviceId(widget.controller.text);
          }
        });
      },
    );

    blue.FlutterBluePlus.startScan();
  }

  void stopScan() {
    blue.FlutterBluePlus.stopScan();
    scanSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: CQColors.iron10,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 60,
                child: ListView.builder(
                  itemCount: scanResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(scanResults[index].device.name ??
                          'dispositivo desconhecido'),
                      subtitle: Text(scanResults[index].device.id.toString()),
                      onTap: () {
                        setState(() {
                          selectedDevice =
                              scanResults[index].device.id.toString();
                          widget.controller.text = selectedDevice!;
                          widget.onChanged?.call(widget.controller.text);

                          deviceCubit.updateDeviceId(selectedDevice!);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    deviceCubit.close();
    scanTimer.cancel();
    super.dispose();
  }
}
*/