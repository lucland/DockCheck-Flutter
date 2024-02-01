import 'package:dockcheck/pages/Dashboard/dashboard_cubit.dart';
import 'package:dockcheck/repositories/authorization_repository.dart';
import 'package:dockcheck/repositories/event_repository.dart';
import 'package:dockcheck/repositories/picture_repository.dart';
import 'package:dockcheck/repositories/user_repository.dart';
import 'package:dockcheck/repositories/vessel_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:dockcheck/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphic/graphic.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      create: (context) => DashboardCubit(
        userRepository,
        eventRepository,
        localStorageService,
        authorizationRepository,
        vesselRepository,
        pictureRepository,
      ),
      child: Container(
        color: CQColors.white,
        child: DashboardView(),
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  DashboardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CQColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              color: CQColors.iron10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Atualizado há: tantos dias',
                      style: CQTheme.h1.copyWith(
                          color: CQColors.iron100,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dia com mais acesso:'.toUpperCase(),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
                        child: Text(
                          'mensagem aqui',
                          style: CQTheme.h3.copyWith(
                            color: CQColors.barrierColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        'Dia com menos acesso'.toUpperCase(),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
                        child: Text(
                          'mensagem aqui',
                          style: CQTheme.h3.copyWith(
                            color: CQColors.barrierColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        'Empresas a bordo'.toUpperCase(),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
                        child: Text(
                          'mensagem aqui',
                          style: CQTheme.h3.copyWith(
                            color: CQColors.barrierColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        'Total de horas'.toUpperCase(),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
                        child: Text(
                          'mensagem aqui',
                          style: CQTheme.h3.copyWith(
                            color: CQColors.barrierColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 200,
                            height: 150,
                            color: CQColors.iron100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'DIA COM',
                                  style: CQTheme.caption1,
                                ),
                                Text(
                                  'MAIS',
                                  style: CQTheme.caption1,
                                ),
                                Text(
                                  'ACESSO',
                                  style: CQTheme.caption1,
                                ),
                                Text(
                                  '00/00',
                                  style: CQTheme.caption1,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                            child: Container(
                              width: 200,
                              height: 150,
                              color: CQColors.iron100,
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 150,
                            color: CQColors.iron100,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(children: [
                            Text('Horas trabalhadas por dia:'),
                            Container(
                              width: 600,
                              height: 300,
                              child: Chart(
                                data: [
                                  {'genre': 'Sports', 'sold': 175},
                                  {'genre': 'Strategy', 'sold': 115},
                                  {'genre': 'Action', 'sold': 120},
                                  {'genre': 'Shooter', 'sold': 350},
                                  {'genre': 'Other', 'sold': 150},
                                ],
                                variables: {
                                  'genre': Variable(
                                    accessor: (Map map) =>
                                        map['genre'] as String,
                                  ),
                                  'sold': Variable(
                                    accessor: (Map map) => map['sold'] as num,
                                  ),
                                },
                                marks: [
                                  IntervalMark(),
                                ],
                                axes: [
                                  Defaults.horizontalAxis,
                                  Defaults.verticalAxis,
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(''),
            Text(''),
          ]),
        ),
      ),
    );
  }
}
