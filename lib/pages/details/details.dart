import 'package:dockcheck/models/document.dart';
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/models/vessel.dart';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/editar/editar.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
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

class DetailsView extends StatelessWidget {
  final String employeeId;

  DetailsView({
    super.key,
    required this.employeeId,
    required Employee employee,
  });

  @override
  Widget build(BuildContext context) {
    context.read<DetailsCubit>().getEmployeeAndDocuments(employeeId);
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        if (state is DetailsLoading) {
          return Scaffold(
              body: const Center(child: CircularProgressIndicator()));
        } else if (state is DetailsError) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Detalhes'),
              ),
              body: Center(child: Text('Error: ${state.message}')));
        } else if (state is DetailsLoaded) {
          final documents = state.documents;
          final employee = state.employee;

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: CQColors.white,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              color: CQColors.iron100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //icon
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8.0, 8, 16, 8),
                                      child: Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: CQColors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(state.employee.name,
                                        style: CQTheme.h1.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Text('|   N° ${employee.number.toString()}',
                                      style: CQTheme.h1
                                          .copyWith(color: Colors.white),
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            // à bordo
                            employee.lastAreaFound != ''
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16),
                                    color: CQColors.success20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: CQColors.success120,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(CQStrings.aBordo + ":",
                                            style: CQTheme.h1.copyWith(
                                                color: CQColors.success120,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(width: 8),
                                        Text(employee.lastAreaFound,
                                            style: CQTheme.h1.copyWith(
                                                color: CQColors.success120,
                                                fontWeight: FontWeight.w600,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      title: 'Ultima vez avistado:',
                                      value:
                                          '${DateFormat('dd/MM/yyyy - HH:mm').format(
                                        state.employee.lastTimeFound
                                            .subtract(Duration(hours: 3)),
                                      )}h'),

                                  // horário de saída do dia, é quando a última vez avistado for no p1;
                                  TitleValueWidget(
                                    title: CQStrings.cpf,
                                    value: employee.cpf,
                                    color: CQColors.iron100,
                                  ),
                                  TitleValueWidget(
                                    title: CQStrings.blood,
                                    value: employee.bloodType, // tipo sanguineo
                                    color: CQColors.iron100,
                                  ),
                                  TitleValueWidget(
                                    title: CQStrings.funcao,
                                    value: employee.role,
                                    color: CQColors.iron100,
                                  ),
                                  TitleValueWidget(
                                    title: CQStrings.empresa,
                                    value: employee.thirdCompanyId,
                                    color: CQColors.iron100,
                                  ),
                                  if (employee.email != '') ...[
                                    TitleValueWidget(
                                      title: CQStrings.email,
                                      value: employee.email,
                                      color: CQColors.iron100,
                                    ),
                                  ],
                                  TitleValueWidget(
                                    title: "Beacon ID",
                                    value: employee.area,
                                    color: CQColors.iron100,
                                  ),
                                ],
                              ),
                            ),
                            /*Padding(
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
                                    /*Row(
                                      children: [
                                        TitleValueWidget(
                                          title: CQStrings.aso,
                                          value:
                                              Formatter.formatDateTime(employee.aso),
                                          color: Formatter.formatDateTime(
                                                          employee.aso)
                                                      .compareTo(Formatter
                                                          .formatDateTime(
                                                              DateTime.now())) <
                                                  0
                                              ? CQColors.danger100
                                              : CQColors.iron100,
                                        ),
                                        if (Formatter.formatDateTime(employee.aso)
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
                                    ),*/
                                    const SizedBox(height: 8),
                                    /*Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TitleValueWidget(
                                          title: CQStrings.nr34,
                                          value:
                                              Formatter.formatDateTime(employee.nr34),
                                          color: Formatter.formatDateTime(
                                                          employee.nr34)
                                                      .compareTo(Formatter
                                                          .formatDateTime(
                                                              DateTime.now())) <
                                                  0
                                              ? CQColors.danger100
                                              : CQColors.iron100,
                                        ),
                                        if (Formatter.formatDateTime(employee.nr34)
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
                                              Formatter.formatDateTime(employee.nr10),
                                          color: Formatter.formatDateTime(
                                                          employee.nr10)
                                                      .compareTo(Formatter
                                                          .formatDateTime(
                                                              DateTime.now())) <
                                                  0
                                              ? CQColors.danger100
                                              : CQColors.iron100,
                                        ),
                                        if (Formatter.formatDateTime(employee.nr10)
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
                                    ),*/
                                    const SizedBox(height: 8),
                                    /*Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TitleValueWidget(
                                          title: CQStrings.nr33,
                                          value:
                                              Formatter.formatDateTime(employee.nr33),
                                          color: Formatter.formatDateTime(
                                                          employee.nr33)
                                                      .compareTo(Formatter
                                                          .formatDateTime(
                                                              DateTime.now())) <
                                                  0
                                              ? CQColors.danger100
                                              : CQColors.iron100,
                                        ),
                                        if (Formatter.formatDateTime(employee.nr33)
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
                                              Formatter.formatDateTime(employee.nr35),
                                          color: Formatter.formatDateTime(
                                                          employee.nr35)
                                                      .compareTo(Formatter
                                                          .formatDateTime(
                                                              DateTime.now())) <
                                                  0
                                              ? CQColors.danger100
                                              : CQColors.iron100,
                                        ),
                                        if (Formatter.formatDateTime(employee.nr35)
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
                                    ),*/
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                            /*Padding(
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
                                            /*Text(
                                              Formatter.formatDateTime(
                                                  employee.startJob),
                                              style: CQTheme.body.copyWith(
                                                color: CQColors.iron100,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),*/
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
                                            /*Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  Formatter.formatDateTime(
                                                      employee.endJob),
                                                  style: CQTheme.body.copyWith(
                                                    color: Formatter.formatDateTime(
                                                                    employee.endJob)
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
                                            ),*/
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                            if (state.employee.lastAreaFound != 'P1' &&
                                state.employee.lastAreaFound != 'P2') ...[
                              /*Padding(
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
                                      //YourWidget(eventos: state.eventos)
                                    ],
                                  ),
                                ),
                              ),
                            ),*/
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Additional Widgets for displaying user details
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('Erro desconhecido'));
        }
      },
    );
  }
}
