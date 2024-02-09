import 'dart:io';
import 'dart:typed_data';

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
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
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

class DashboardView extends StatefulWidget {
  DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DateTimeRange? _selectedDateRange;

  final ScrollController _scrollController = ScrollController();

  Future<void> _exportAsPdf() async {
    RenderRepaintBoundary boundary =
        _scrollController.position.context.storageContext.findRenderObject()
            as RenderRepaintBoundary;

    try {
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List uint8List = byteData.buffer.asUint8List();

        final pdf = pw.Document();

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Image(
              pw.MemoryImage(uint8List),
            ),
          ),
        );

        final output = await getExternalStorageDirectory();
        final file = File('${output?.path}/dashboard_export.pdf');
        await file.writeAsBytes(pdf.save() as List<int>);

        print('PDF Exported: ${file.path}');
      } else {
        print('Error: ByteData is null');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String _formatMonth(int month) {
    // O método DateFormat.MMM() retorna as três primeiras letras do nome do mês
    return DateFormat.MMM().format(DateTime(2022, month, 1));
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(Duration(days: 7)),
          ),
    );

    if (pickedDateRange != null && pickedDateRange != _selectedDateRange) {
      setState(() {
        _selectedDateRange = pickedDateRange;
      });
    }
  }

  Future<void> _refreshData() async {
    // Aqui você pode adicionar a lógica de recarregar os dados
    // Pode ser chamada uma função para recarregar os dados da API, por exemplo
    // Aguarde um tempo fictício para simular a recarga de dados
    await Future.delayed(Duration(seconds: 2));
  }

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime startDate;
    DateTime endDate;

    return RepaintBoundary(
      child: Scaffold(
        backgroundColor: CQColors.background,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: RepaintBoundary(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12, top: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ultimas métricas',
                                        style: TextStyle(
                                            color: CQColors.iron80,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showDateRangePicker(context);
                                            },
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedDateRange =
                                                                null;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: _selectedDateRange ==
                                                                          null
                                                                      ? CQColors
                                                                          .iron100
                                                                      : Colors
                                                                          .transparent,
                                                                  border: Border
                                                                      .all(
                                                                    width: 1,
                                                                    color: _selectedDateRange ==
                                                                            null
                                                                        ? CQColors
                                                                            .iron100
                                                                        : Colors
                                                                            .transparent,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child: Text(
                                                                'Hoje',
                                                                style:
                                                                    TextStyle(
                                                                  color: _selectedDateRange ==
                                                                          null
                                                                      ? CQColors
                                                                          .white
                                                                      : CQColors
                                                                          .iron100,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _showDateRangePicker(
                                                                context),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: _selectedDateRange !=
                                                                          null
                                                                      ? CQColors
                                                                          .iron100
                                                                      : Colors
                                                                          .transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Selecionar data ',
                                                                        style:
                                                                            TextStyle(
                                                                          color: _selectedDateRange != null
                                                                              ? Colors.white
                                                                              : CQColors.iron100,
                                                                          fontWeight:
                                                                              FontWeight.w800,
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                        color: _selectedDateRange !=
                                                                                null
                                                                            ? CQColors.white
                                                                            : CQColors.iron100,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Areas mais acessadas da embarcacao',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 16),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Container(
                                                    width: 500,
                                                    height: 300,
                                                    child: PieChart(
                                                      PieChartData(
                                                        sectionsSpace: 1,
                                                        centerSpaceRadius: 30,
                                                        sections: [
                                                          PieChartSectionData(
                                                            titleStyle: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: CQColors
                                                                    .white),
                                                            color: CQColors
                                                                .danger100,
                                                            value: 40,
                                                            title: '40%',
                                                            radius: 100,
                                                          ),
                                                          PieChartSectionData(
                                                            titleStyle: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: CQColors
                                                                    .white),
                                                            color: CQColors
                                                                .success90,
                                                            value: 30,
                                                            title: '30%',
                                                            radius: 100,
                                                          ),
                                                          PieChartSectionData(
                                                            titleStyle: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: CQColors
                                                                    .white),
                                                            color: CQColors
                                                                .systemBlue110,
                                                            value: 20,
                                                            title: '20%',
                                                            radius: 100,
                                                          ),
                                                          PieChartSectionData(
                                                            titleStyle: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: CQColors
                                                                    .white),
                                                            color: CQColors
                                                                .warning110,
                                                            value: 20,
                                                            title: '20%',
                                                            radius: 100,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CQColors
                                                              .systemBlue110,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        width: 12,
                                                        height: 12,
                                                      ),
                                                      Text(' Convés'),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CQColors
                                                              .warning110,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        width: 12,
                                                        height: 12,
                                                      ),
                                                      Text(' Passadisso')
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CQColors
                                                              .success90,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        width: 12,
                                                        height: 12,
                                                      ),
                                                      Text(' Praca de maquinas')
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(_selectedDateRange != null
                                                ? '${_selectedDateRange!.start.day} - ${_selectedDateRange!.end.day} ${_formatMonth(_selectedDateRange!.start.month)} - ${_formatMonth(_selectedDateRange!.end.month)}, ${_selectedDateRange!.end.year}'
                                                : DateFormat('dd MMM, yyyy')
                                                    .format(DateTime.now())),
                                            Text(
                                              '...',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Horas trabalhadas por empresa',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, bottom: 16),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Container(
                                                    width: 680,
                                                    height: 300,
                                                    child: BarChart(
                                                      BarChartData(
                                                        alignment:
                                                            BarChartAlignment
                                                                .spaceAround,
                                                        maxY: 10,
                                                        barTouchData:
                                                            BarTouchData(
                                                          touchTooltipData:
                                                              BarTouchTooltipData(
                                                            tooltipBgColor:
                                                                Colors
                                                                    .blueAccent,
                                                          ),
                                                        ),
                                                        titlesData:
                                                            FlTitlesData(
                                                          show: true,
                                                        ),
                                                        borderData:
                                                            FlBorderData(
                                                          show: true,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 1),
                                                        ),
                                                        barGroups: [
                                                          BarChartGroupData(
                                                            x: 8,
                                                            barRods: [
                                                              BarChartRodData(
                                                                  color: CQColors
                                                                      .iron80,
                                                                  toY: 1,
                                                                  width: 15,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .zero)
                                                            ],
                                                          ),
                                                          BarChartGroupData(
                                                            x: 10,
                                                            barRods: [
                                                              BarChartRodData(
                                                                  color: CQColors
                                                                      .iron80,
                                                                  toY: 2,
                                                                  width: 15,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .zero)
                                                            ],
                                                          ),
                                                          BarChartGroupData(
                                                            x: 5,
                                                            barRods: [
                                                              BarChartRodData(
                                                                  color: CQColors
                                                                      .iron80,
                                                                  toY: 3,
                                                                  width: 15,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .zero)
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ]),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_selectedDateRange != null
                                              ? '${_selectedDateRange!.start.day} - ${_selectedDateRange!.end.day} ${_formatMonth(_selectedDateRange!.start.month)} - ${_formatMonth(_selectedDateRange!.end.month)}, ${_selectedDateRange!.end.year}'
                                              : DateFormat('dd MMM, yyyy')
                                                  .format(DateTime.now())),
                                          Text(
                                            '...',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 35,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Empresas com maior numero de horas trabalhadas:'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Quantidade de acessos por empresa',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0, bottom: 16),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Container(
                                                      width:
                                                          680, // Largura desejada
                                                      height:
                                                          300, // Altura desejada
                                                      child: Chart(
                                                        data: [
                                                          {
                                                            'genre': 'Telnav',
                                                            'sold': 900
                                                          },
                                                          {
                                                            'genre': 'Camorim',
                                                            'sold': 980
                                                          },
                                                          {
                                                            'genre': 'Dof',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof1',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof2',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof3',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof4',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof5',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof6',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof7',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof8',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof9',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof10',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof11',
                                                            'sold': 1204
                                                          },
                                                          {
                                                            'genre': 'Dof13',
                                                            'sold': 1204
                                                          },
                                                        ],
                                                        variables: {
                                                          'genre': Variable(
                                                            accessor: (Map
                                                                    map) =>
                                                                map['genre']
                                                                    as String,
                                                          ),
                                                          'sold': Variable(
                                                            accessor:
                                                                (Map map) =>
                                                                    map['sold']
                                                                        as num,
                                                          ),
                                                        },
                                                        marks: [
                                                          IntervalMark(
                                                            color: ColorEncode(
                                                                value: CQColors
                                                                    .iron80),
                                                          ),
                                                        ],
                                                        axes: [
                                                          Defaults
                                                              .horizontalAxis,
                                                          Defaults.verticalAxis,
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ]),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(_selectedDateRange != null
                                                ? '${_selectedDateRange!.start.day} - ${_selectedDateRange!.end.day} ${_formatMonth(_selectedDateRange!.start.month)} - ${_formatMonth(_selectedDateRange!.end.month)}, ${_selectedDateRange!.end.year}'
                                                : DateFormat('dd MMM, yyyy')
                                                    .format(DateTime.now())),
                                            Text(
                                              '...',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 35,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Empresas com maior numero de colaboradores a bordo:'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 8, 20, 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    'Total de pessoas cadastradas: 23.458',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: CQColors
                                                            .success100),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: CQColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _exportAsPdf();
                                      },
                                      child: Container(
                                        child: Center(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'EXPORTAR COMO PDF ',
                                                  style: TextStyle(
                                                      color: CQColors.iron80,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Icon(
                                                  Icons.send_and_archive,
                                                  color: CQColors.iron80,
                                                )
                                              ]),
                                        ),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: CQColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              width: 1, color: CQColors.iron80),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
