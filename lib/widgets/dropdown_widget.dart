import 'dart:io';

import 'package:dockcheck/models/my_device.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: CQColors.iron100,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: 'SKANDI AMAZONAS',
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: CQColors.iron100,
            ),
            iconSize: 32,
            alignment: Alignment.centerRight,
            elevation: 2,
            style: CQTheme.h2.copyWith(
              color: CQColors.iron100,
            ),
            selectedItemBuilder: (BuildContext context) {
              return <String>[
                'SKANDI AMAZONAS',
                'SKANDI IGUAÇU',
                'SKANDI FLUMINENSE',
                'SKANDI URCA'
              ].map<Widget>((String value) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    style: CQTheme.h2.copyWith(
                      color: CQColors.iron100,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList();
            },
            onChanged: (String? newValue) {},
            underline: Container(
              height: 0,
              color: CQColors.iron100,
            ),
            items: <String>[
              'SKANDI AMAZONAS',
              'SKANDI IGUAÇU',
              'SKANDI FLUMINENSE',
              'SKANDI URCA'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
