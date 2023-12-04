import 'package:cripto_qr_googlemarine/utils/formatter.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/user.dart';

import '../../repositories/user_repository.dart';
import '../../services/local_storage_service.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/sync_button_widget.dart';
import '../../widgets/semi_circle_painter.dart';
import '../../widgets/title_value_widget.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    final LocalStorageService localStorageService =
        Provider.of<LocalStorageService>(context, listen: false);

    return BlocProvider(
      create: (context) => HomeCubit(userRepository, localStorageService),
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

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          User user = state.loggedUser!;
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
                    'Olá, ${user.name}',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SyncButtonWidget(
                      onPressed: () {
                        //push to bluetooth page
                        Navigator.pushNamed(context, '/bluetooth');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        CQStrings.atualizadoEm(
                            Formatter.formatDateTime(user.updatedAt)),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                //text with 'last sync at
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
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleValueWidget(
                          title: CQStrings.empresa, value: user.company),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(user.number.toString(),
                      style: CQTheme.h1
                          .copyWith(fontSize: 38, color: Colors.black)),
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
              'À bordo',
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
              CQStrings.atualizadoEm(Formatter.formatDateTime(user.updatedAt)),
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
        Center(
          child: Text(user.number.toString(),
              style: CQTheme.h1.copyWith(fontSize: 38, color: Colors.black)),
        ),
      ],
    );
  }
}
