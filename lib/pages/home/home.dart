import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cripto_qr_googlemarine/blocs/home/home_cubit.dart';
import 'package:cripto_qr_googlemarine/blocs/home/home_state.dart';
import 'package:cripto_qr_googlemarine/utils/formatter.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/user.dart';

import '../../repositories/user_repository.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/print_button_widget.dart';
import '../../widgets/semi_circle_painter.dart';
import '../../widgets/title_value_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(UserRepository()),
      child: Container(
        color: CQColors.white,
        child: const HomeView(),
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
                content: Text(CQStrings.qrCodeSalvoNaGaleria,
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
          return Container(
            color: CQColors.background,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    CQStrings.benVindoABordo,
                    style: CQTheme.h3.copyWith(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            TicketHeader(user: user),
                            TicketBody(
                              user: user,
                              data: user.toDatabaseString(),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 48,
                          left: -10,
                          child: CustomPaint(
                            size: const Size(20, 10),
                            painter: CirclePainter(
                              color: CQColors.background,
                              direction: Direction.left,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 48,
                          right: -10,
                          child: CustomPaint(
                            size: const Size(20, 10),
                            painter: CirclePainter(
                              color: CQColors.background,
                              direction: Direction.right,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 48,
                          left: -10,
                          child: CustomPaint(
                            size: const Size(20, 10),
                            painter: CirclePainter(
                              color: CQColors.background,
                              direction: Direction.right,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 48,
                          right: -10,
                          child: CustomPaint(
                            size: const Size(20, 10),
                            painter: CirclePainter(
                              color: CQColors.background,
                              direction: Direction.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*  RepaintBoundary(
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
                ),*/
                const Spacer(),
                PrintButtonWidget(
                  onPressed: () {
                    //push to bluetooth page
                    Navigator.pushNamed(context, '/bluetooth');
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class TicketBody extends StatelessWidget {
  const TicketBody({
    super.key,
    required this.user,
    required this.data,
  });

  final User user;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: CQColors.white,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleValueWidget(
                    title: CQStrings.embarcacao, value: user.vessel),
                const SizedBox(height: 16),
                TitleValueWidget(title: CQStrings.funcao, value: user.funcao),
                const SizedBox(height: 16),
                TitleValueWidget(title: CQStrings.empresa, value: user.empresa),
              ],
            ),
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EstadiaWidget(user: user),
                ),
              ),
              Flexible(
                flex: 1,
                child: QrCodeWidget(
                  data: data,
                ),
              ),
            ],
          ),
          const Divider(),
          TicketFooter(user: user),
        ],
      ),
    );
  }
}

class TicketHeader extends StatelessWidget {
  const TicketHeader({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: CQColors.iron100,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.nome,
              style: CQTheme.h3.copyWith(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class TicketFooter extends StatelessWidget {
  const TicketFooter({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: CQColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, color: CQColors.slate100, size: 14),
            const SizedBox(width: 8),
            Text(
              CQStrings.atualizadoEm(
                  Formatter.formatDateTime(user.updatedAt.toDate())),
              style: CQTheme.body.copyWith(
                color: CQColors.slate100,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class QrCodeWidget extends StatelessWidget {
  final String data;
  const QrCodeWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
          ),
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Text(
            CQStrings.poweredBy,
            style: CQTheme.body.copyWith(
              color: CQColors.slate100,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class EstadiaWidget extends StatelessWidget {
  const EstadiaWidget({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CQStrings.estadia,
              style: CQTheme.body.copyWith(
                color: CQColors.slate100,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    CQStrings.de,
                    style: CQTheme.body.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    Formatter.formatDateTime(user.dataInicial.toDate()),
                    style: CQTheme.body.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CQStrings.ate,
                  style: CQTheme.body.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  Formatter.formatDateTime(user.dataLimite.toDate()),
                  style: CQTheme.body.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(user.numero.toString(),
              style: CQTheme.h1.copyWith(fontSize: 38, color: Colors.black)),
        ),
      ],
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
