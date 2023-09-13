import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_qr_googlemarine/blocs/home/home_cubit.dart';
import 'package:cripto_qr_googlemarine/blocs/home/home_state.dart';
import 'package:cripto_qr_googlemarine/utils/formatter.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/user.dart';

import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../../repositories/user_repository.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(UserRepository()),
      child: Container(
        color: CQColors.white,
        child: HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().fetchLastUser();
    final GlobalKey globalKey = GlobalKey();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        Future<void> convertWidgetToImage() async {
          try {
            RenderRepaintBoundary boundary = globalKey.currentContext!
                .findRenderObject() as RenderRepaintBoundary;

            // Get the device's pixel ratio
            final double devicePixelRatio =
                MediaQuery.of(globalKey.currentContext!).devicePixelRatio;

            // Convert mm to inches (1 inch = 25.4 mm)
            //    final double heightInInches = 63 / 25.4;
            const double widthInInches = 85 / 25.4;

            // Calculate the target dimensions in pixels
            //   final double targetHeightInPixels = heightInInches *
            //     devicePixelRatio *
            //    96; // 96 is the DPI for flutter in most cases
            final double targetWidthInPixels =
                widthInInches * devicePixelRatio * 96;

            ui.Image image = await boundary.toImage(
                pixelRatio: targetWidthInPixels / boundary.size.width);
            ByteData? byteData =
                await image.toByteData(format: ui.ImageByteFormat.png);
            Uint8List pngBytes = byteData!.buffer.asUint8List();

            //present image in dialog
            showDialog(
              context: globalKey.currentContext!,
              builder: (context) => AlertDialog(
                content: Image.memory(pngBytes),
              ),
            );

            final Image pngImage = Image.memory(pngBytes);

            printPngImage(pngBytes);

            final result = await ImageGallerySaver.saveImage(
                pngBytes.buffer.asUint8List());
            print(result);
            //return snackbar
            ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text('QR Code salvo na galeria',
                    style: CQTheme.body.copyWith(color: CQColors.white)),
                backgroundColor: CQColors.success100,
              ),
            );

            // Now pngBytes contains the PNG image data with dimensions close to 63mm x 85mm.
            // You can write it to a file or do something else with it.

            //save to gallery
          } catch (e) {
            print(e);
          }
        }

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          User user = state.user!;
          return SingleChildScrollView(
            child: Container(
              color: CQColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Bem vindo(a) a bordo no ${user.vessel},",
                          style: CQTheme.h3,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          user.nome,
                          style: CQTheme.h1,
                        ),
                        Text(
                          "Empresa: ${user.empresa} | N°${user.numero}",
                          style: CQTheme.h3,
                        ),
                        Text(
                          "Cadastrado dia ${user.createdAt.toDate().day}/${user.createdAt.toDate().month}/${user.createdAt.toDate().year}",
                          style: CQTheme.h3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  RepaintBoundary(
                    key: globalKey,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 16, 0, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(user.nome,
                                      style: CQTheme.h1.copyWith(
                                        fontSize: 10,
                                      )),
                                  Text(
                                    user.funcao,
                                    style: CQTheme.h2.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    user.empresa,
                                    style: CQTheme.h3.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    user.numero.toString(),
                                    style: CQTheme.h1.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    user.identidade,
                                    style: CQTheme.subhead1.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: QrImageView(
                                data: state.user!.toDatabaseString(),
                                version: QrVersions.auto,
                                size: 300.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //show generated png image from convertWidgetToImage function
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        convertWidgetToImage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Imprimir QR Code',
                          style: CQTheme.h2.copyWith(
                              color: CQColors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ProximaNova'),
                        ),
                      ),
                    ),
                  ),
                  /*QrImageView(
                    data: state.user!.toDatabaseString(),
                    version: QrVersions.auto,
                    size: 600.0,
                  ),*/
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                  ListTile(
                    title: const Text('Identidade'),
                    subtitle: Text(user.identidade),
                  ),
                  ListTile(
                    title: const Text('Embarcação'),
                    subtitle: Text(user.vessel),
                  ),
                  ListTile(
                    title: const Text('ASO'),
                    subtitle: Text(Formatter.fromTimestamp(user.ASO)),
                  ),
                  ListTile(
                    title: const Text('NR10'),
                    subtitle: Text(Formatter.fromTimestamp(user.NR10)),
                  ),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

Future<void> printPngImage(Uint8List pngBytes) async {
  //final profile = await CapabilityProfile.load();

  // final printer = NetworkPrinter(PaperSize.mm80, profile);

  //final connect = await printer.connect('192.168.0.123', port: 9100);

  // printer.cut();
  // printer.disconnect();
}
