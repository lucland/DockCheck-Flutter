import 'dart:io';

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

class DropDown extends StatelessWidget {
  final Device? connectedDevice;

  const DropDown({Key? key, this.connectedDevice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${connectedDevice?.name ?? connectedDevice?.address ?? 'Desconhecido'} conectado',
      style: TextStyle(
        color: CQColors.iron100,
      ),
    );
  }
}
