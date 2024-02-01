import 'package:dockcheck/models/vessel.dart';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/editar/editar.dart';
import 'package:dockcheck/repositories/event_repository.dart';
import 'package:dockcheck/repositories/picture_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/ui/ui.dart';
import 'package:dockcheck/widgets/bluetooth_scan_button_widget.dart';
import 'package:dockcheck/widgets/calendar_picker_widget.dart';
import 'package:dockcheck/widgets/checkout_button_widget.dart';
import 'package:dockcheck/widgets/events.dart';
import 'package:dockcheck/widgets/switcher_widget.dart';
import 'package:dockcheck/widgets/sync_button_widget.dart';
import 'package:dockcheck/widgets/text_input_widget.dart';
import 'package:dockcheck/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/event.dart';
import '../../models/user.dart';
import '../../repositories/authorization_repository.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/vessel_repository.dart';
import '../../utils/enums/action_enum.dart';
import '../../utils/theme.dart';
import 'cubit/details_cubit.dart';
import 'cubit/details_state.dart';

class Details extends StatelessWidget {
  final User user;

  const Details({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    final EventRepository eventRepository =
        Provider.of<EventRepository>(context);
    final LocalStorageService localStorageService =
        Provider.of<LocalStorageService>(context);
    final AuthorizationRepository authorizationRepository =
        Provider.of<AuthorizationRepository>(context);
    final VesselRepository vesselRepository =
        Provider.of<VesselRepository>(context);
    final PictureRepository pictureRepository =
        Provider.of<PictureRepository>(context);

    return BlocProvider(
      create: (context) => DetailsCubit(
        userRepository,
        eventRepository,
        localStorageService,
        authorizationRepository,
        vesselRepository,
        pictureRepository,
      ),
      child: Container(
        color: CQColors.white,
        child: DetailsView(
          user: user,
        ),
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final User user;

  DetailsView({
    super.key,
    required this.user,
  });

  void scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    context.read<DetailsCubit>().fetchEvents(user.id, user.picture);

    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        if (state is DetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DetailsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DetailsLoaded) {
          return Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: FloatingActionButton(
                backgroundColor: CQColors.iron100,
                onPressed: () {
                  scrollToTop();
                },
                child: Icon(
                  Icons.swipe_up,
                  color: CQColors.white,
                ),
              ),
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Editar(
                          user: user,
                          onSalvar: () => Navigator.pop,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: CQColors.iron100,
                  ),
                ),
              ],
              backgroundColor: CQColors.background,
              foregroundColor: CQColors.iron100,
              elevation: 0,
              title: const Text(CQStrings.informacoes,
                  style: CQTheme.h2, overflow: TextOverflow.ellipsis),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          color: CQColors.iron100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(user.name,
                                    style: CQTheme.h1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text('|   N° ${user.number.toString()}',
                                  style:
                                      CQTheme.h1.copyWith(color: Colors.white),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        user.isOnboarded
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                color: CQColors.success20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: CQColors.success120,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(CQStrings.aBordo,
                                        style: CQTheme.h1.copyWith(
                                            color: CQColors.success120,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                color: Color.fromARGB(255, 240, 228, 228),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cancel,
                                      color: CQColors.danger110,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(CQStrings.naoaBordo,
                                        style: CQTheme.h1.copyWith(
                                            color: CQColors.danger110,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleValueWidget(
                                title: 'horário de entrada:',
                                value: (() {
                                  for (int i = state.eventos.length - 1;
                                      i >= 0;
                                      i--) {
                                    final portalId =
                                        state.eventos[i].portalId.toString();
                                    if (portalId != 'P1' && portalId != '0') {
                                      return '$portalId - ${DateFormat('dd/MM/yyyy - HH:mm').format(
                                        state.eventos[i].timestamp
                                            .subtract(Duration(hours: 3)),
                                      )}';
                                    }
                                  }
                                  return 'não possui horário de entrada';
                                })(),
                              ),
                              // primeira entrada do dia, é quando a primeira vez avistado é diferente de p1;
                              TitleValueWidget(
                                title: 'horário de saída:',
                                value: (() {
                                  if (state.eventos.isNotEmpty &&
                                      state.eventos.first.portalId.toString() ==
                                          'P1') {
                                    return '${state.eventos.first.portalId} - ${DateFormat('dd/MM/yyyy - HH:mm').format(
                                      state.eventos.first.timestamp
                                          .subtract(Duration(hours: 3)),
                                    )}';
                                  } else {
                                    return 'não possui horário de saída';
                                  }
                                })(),
                              ),
                              // horário de saída do dia, é quando a última vez avistado for no p1;
                              TitleValueWidget(
                                title: CQStrings.cpf,
                                value: user.cpf,
                                color: CQColors.iron100,
                              ),
                              TitleValueWidget(
                                  title: CQStrings.itag, value: user.iTag),
                              TitleValueWidget(
                                title: CQStrings.blood,
                                value: user.bloodType, // tipo sanguineo
                                color: CQColors.iron100,
                              ),
                              TitleValueWidget(
                                title: CQStrings.funcao,
                                value: user.role,
                                color: CQColors.iron100,
                              ),
                              TitleValueWidget(
                                title: CQStrings.empresa,
                                value: user.company,
                                color: CQColors.iron100,
                              ),
                              if (user.email != '') ...[
                                TitleValueWidget(
                                  title: CQStrings.email,
                                  value: user.email,
                                  color: CQColors.iron100,
                                ),
                              ],
                              TitleValueWidget(
                                title: CQStrings.area,
                                value: user.area,
                                color: CQColors.iron100,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: CQColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    CQStrings.validades,
                                    style: CQTheme.h1.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                    child: Divider(
                                      color: CQColors.slate100,
                                      thickness: 0.3,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TitleValueWidget(
                                        title: CQStrings.aso,
                                        value:
                                            Formatter.formatDateTime(user.aso),
                                        color: Formatter.formatDateTime(
                                                        user.aso)
                                                    .compareTo(Formatter
                                                        .formatDateTime(
                                                            DateTime.now())) <
                                                0
                                            ? CQColors.danger100
                                            : CQColors.iron100,
                                      ),
                                      if (Formatter.formatDateTime(user.aso)
                                              .compareTo(
                                                  Formatter.formatDateTime(
                                                      DateTime.now())) <
                                          0)
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: 4,
                                              height: 16,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 265.0),
                                              child: Text(
                                                ' Aso expirado',
                                                style: TextStyle(
                                                  color: CQColors.danger100,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TitleValueWidget(
                                        title: CQStrings.nr34,
                                        value:
                                            Formatter.formatDateTime(user.nr34),
                                        color: Formatter.formatDateTime(
                                                        user.nr34)
                                                    .compareTo(Formatter
                                                        .formatDateTime(
                                                            DateTime.now())) <
                                                0
                                            ? CQColors.danger100
                                            : CQColors.iron100,
                                      ),
                                      if (Formatter.formatDateTime(user.nr34)
                                              .compareTo(
                                                  Formatter.formatDateTime(
                                                      DateTime.now())) <
                                          0)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ' NR34 expirado',
                                                  style: TextStyle(
                                                    color: CQColors.danger100,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      TitleValueWidget(
                                        title: CQStrings.nr10,
                                        value:
                                            Formatter.formatDateTime(user.nr10),
                                        color: Formatter.formatDateTime(
                                                        user.nr10)
                                                    .compareTo(Formatter
                                                        .formatDateTime(
                                                            DateTime.now())) <
                                                0
                                            ? CQColors.danger100
                                            : CQColors.iron100,
                                      ),
                                      if (Formatter.formatDateTime(user.nr10)
                                              .compareTo(
                                                  Formatter.formatDateTime(
                                                      DateTime.now())) <
                                          0)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ' NR10 expirado',
                                                  style: TextStyle(
                                                    color: CQColors.danger100,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TitleValueWidget(
                                        title: CQStrings.nr33,
                                        value:
                                            Formatter.formatDateTime(user.nr33),
                                        color: Formatter.formatDateTime(
                                                        user.nr33)
                                                    .compareTo(Formatter
                                                        .formatDateTime(
                                                            DateTime.now())) <
                                                0
                                            ? CQColors.danger100
                                            : CQColors.iron100,
                                      ),
                                      if (Formatter.formatDateTime(user.nr33)
                                              .compareTo(
                                                  Formatter.formatDateTime(
                                                      DateTime.now())) <
                                          0)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ' NR33 expirado',
                                                  style: TextStyle(
                                                    color: CQColors.danger100,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      TitleValueWidget(
                                        title: CQStrings.nr35,
                                        value:
                                            Formatter.formatDateTime(user.nr35),
                                        color: Formatter.formatDateTime(
                                                        user.nr35)
                                                    .compareTo(Formatter
                                                        .formatDateTime(
                                                            DateTime.now())) <
                                                0
                                            ? CQColors.danger100
                                            : CQColors.iron100,
                                      ),
                                      if (Formatter.formatDateTime(user.nr35)
                                              .compareTo(
                                                  Formatter.formatDateTime(
                                                      DateTime.now())) <
                                          0)
                                        Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                ' NR35 expirado',
                                                style: TextStyle(
                                                  color: CQColors.danger100,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: CQColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        CQStrings.estadia,
                                        style: CQTheme.h1.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                        child: Divider(
                                          color: CQColors.iron100,
                                          thickness: 0.3,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            CQStrings.de,
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            Formatter.formatDateTime(
                                                user.startJob),
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            CQStrings.ate,
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                Formatter.formatDateTime(
                                                    user.endJob),
                                                style: CQTheme.body.copyWith(
                                                  color: Formatter.formatDateTime(
                                                                  user.endJob)
                                                              .compareTo(Formatter
                                                                  .formatDateTime(
                                                                      DateTime
                                                                          .now())) <
                                                          0
                                                      ? CQColors.danger100
                                                      : CQColors.iron100,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (state.eventos != null &&
                            state.eventos.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 16),
                            child: Card(
                              color: CQColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      CQStrings.eventos,
                                      style: CQTheme.h1.copyWith(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                      child: Divider(
                                        color: CQColors.slate100,
                                        thickness: 0.3,
                                      ),
                                    ),
                                    YourWidget(eventos: state.eventos)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SyncButtonWidget(
                      onPressed: () {
                        context
                            .read<DetailsCubit>()
                            .fetchEvents(user.id, user.picture);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Erro desconhecido'));
        }
      },
    );
  }

  List<Widget> _buildEventContainers(
      BuildContext context, List<Event> eventos) {
    Map<String, List<Event>> eventsByDate = {};

    for (Event evento in eventos) {
      print(evento.portalId);
      String formattedDate = Formatter.formatDateTime(
        evento.timestamp,
      );
      eventsByDate.putIfAbsent(formattedDate, () => []);
      eventsByDate[formattedDate]!.add(evento);
    }

    List<Widget> containers = [];
    eventsByDate.forEach((date, events) {
      containers.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 1, color: CQColors.iron100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      date,
                      style: CQTheme.h3,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: events.map((event) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actionEnumToString(event.action),
                      style: CQTheme.body.copyWith(
                        color: CQColors.iron100,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            event.portalId,
                            style: CQTheme.body.copyWith(
                              color: CQColors.iron100,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          ' -',
                          style: CQTheme.body2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            Formatter.fromatHourDateTime(
                              event.timestamp.subtract(Duration(hours: 3)),
                            ),
                            style: CQTheme.body.copyWith(
                              color: CQColors.iron100,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            event.id,
                            style: CQTheme.body.copyWith(
                              color: CQColors.iron100,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    });

    return containers;
  }
}
