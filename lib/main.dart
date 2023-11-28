import 'package:cripto_qr_googlemarine/pages/login/login.dart';
import 'package:cripto_qr_googlemarine/pages/root/root.dart';
import 'package:cripto_qr_googlemarine/utils/simple_blo_observer.dart';
import 'package:cripto_qr_googlemarine/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Bloc.observer = SimpleBlocObserver();

  SimpleLogger.shared.set(level: LoggerLevel.info, mode: LoggerMode.log);

  SimpleLogger.info('Launching -----');
  SimpleLogger.info('App ID: ${packageInfo.packageName}');
  SimpleLogger.info('Version: ${packageInfo.version}');

  runApp(
    MaterialApp(
      theme: CQTheme.theme,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
