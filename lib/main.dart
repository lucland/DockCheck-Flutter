import 'package:cripto_qr_googlemarine/pages/root/root.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        theme: CQTheme.theme,
        home: Root(),
        debugShowCheckedModeBanner: false,
      ),
    );
