import 'dart:async';

import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/pages/cadastrar/cubit/doc_enum.dart';
import 'package:dockcheck/repositories/event_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/widgets/bluetooth_scan_button_widget.dart';
import 'package:dockcheck/widgets/image_picker_widget.dart';
import 'package:dockcheck/widgets/switcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:intl/intl.dart';

import '../../repositories/user_repository.dart';
import '../../utils/theme.dart';
import '../../utils/ui/colors.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/calendar_picker_widget.dart';
import '../../widgets/text_input_widget.dart';
import 'cubit/cadastrar_cubit.dart';
import 'cubit/cadastrar_state.dart';

class Cadastrar extends StatelessWidget {
  final VoidCallback onCadastrar;
  final UserRepository userRepository;
  final EventRepository eventRepository;
  final LocalStorageService localStorageService;

  const Cadastrar({
    super.key,
    required this.onCadastrar,
    required this.userRepository,
    required this.eventRepository,
    required this.localStorageService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CadastrarCubit(
        userRepository,
        eventRepository,
        localStorageService,
      ),
      child: CadastrarView(onCadastrar: onCadastrar),
    );
  }
}

class CadastrarView extends StatefulWidget {
  final VoidCallback onCadastrar;

  const CadastrarView({super.key, required this.onCadastrar});

  @override
  State<CadastrarView> createState() => _CadastrarViewState();
}

class _CadastrarViewState extends State<CadastrarView> {
  final TextEditingController areaController = TextEditingController();
  final TextEditingController datetimeController = TextEditingController();
  final TextEditingController liberadoPorController = TextEditingController();
  final TextEditingController nameVisitorController = TextEditingController();
  final TextEditingController nameUserController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bloodtypeController = TextEditingController();

  final TextEditingController asoController =
      TextEditingController(text: '00/00/0000');

  final TextEditingController nr34Controller =
      TextEditingController(text: '00/00/0000');

  final TextEditingController nr10Controller =
      TextEditingController(text: '00/00/0000');

  final TextEditingController nr33Controller =
      TextEditingController(text: '00/00/0000');

  final TextEditingController nr35Controller =
      TextEditingController(text: '00/00/0000');

  final TextEditingController dataInicialController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  final TextEditingController dataFinalController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  void clearFields() {
    liberadoPorController.clear();
    nameVisitorController.clear();
    nameUserController.clear();
    roleController.clear();
    companyController.clear();
    emailController.clear();
    bloodtypeController.clear();
  }

  @override
  void initState() {
    super.initState();
    context.read<CadastrarCubit>().startScan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildBluetoothScanSection(
      BuildContext context, CadastrarState state) {
    final CadastrarCubit cubit = context.read<CadastrarCubit>();

    return BluetoothScanButton(cubit: cubit);
  }

  @override
  Widget build(BuildContext context) {
    final CadastrarCubit cubit = context.read<CadastrarCubit>();

    return BlocConsumer<CadastrarCubit, CadastrarState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.isLoading) {
          cubit.fetchNumero();
          return const Center(child: CircularProgressIndicator());
        } else {
          return _buildForm(context, state, cubit);
        }
      },
    );
  }

  Widget _buildForm(
      BuildContext context, CadastrarState state, CadastrarCubit cubit) {
    // Extracted form building logic goes here
    return Scaffold(
      backgroundColor: CQColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildHeader(state, cubit),
              _buildFields(state, cubit, context, state.user.isVisitor),
              _buildFooter(state, cubit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CadastrarState state, CadastrarCubit cubit) {
    bool isVisitor = state.user.isVisitor;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('N° ${state.user.number}', style: CQTheme.h1),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: InkWell(
                onTap: () {
                  cubit.updateIsVisitante(!state.user.isVisitor);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 8.0, left: 8),
                          decoration: BoxDecoration(
                            color:
                                isVisitor ? CQColors.iron100 : CQColors.white,
                            border: Border.all(
                                color: isVisitor
                                    ? CQColors.white
                                    : CQColors.iron100),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            CQStrings.visitante,
                            overflow: TextOverflow.ellipsis,
                            style: CQTheme.h3.copyWith(
                                color: isVisitor
                                    ? CQColors.white
                                    : CQColors.iron100),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            color:
                                !isVisitor ? CQColors.iron100 : CQColors.white,
                            border: Border.all(
                                color: !isVisitor
                                    ? CQColors.white
                                    : CQColors.iron100),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            CQStrings.usuario,
                            overflow: TextOverflow.ellipsis,
                            style: CQTheme.h3.copyWith(
                                color: !isVisitor
                                    ? CQColors.white
                                    : CQColors.iron100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        _buildBluetoothScanSection(context, state),
      ],
    );
  }

  Widget _buildFields(CadastrarState state, CadastrarCubit cubit,
      BuildContext context, bool isVisitor) {
    return Column(children: [
      Row(
        children: [
          Flexible(
            flex: 7,
            child: isVisitor
                ? _buildVisitorHeader(state, cubit)
                : _buildUserHeader(state, cubit),
          ),
          Flexible(
            flex: 3,
            child: ImagePickerWidget(cubit: cubit),
          ),
        ],
      ),
      if (!isVisitor) ...[
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                CQStrings.area,
                style: CQTheme.h2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8, 16.0),
          child: SwitcherWidget(
              onTap: (txt) => cubit.updateArea(txt),
              activeArea: state.user.area),
        ),
        InkWell(
          onTap: () {
            cubit.alternarVisibilidadeDocumentos();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    state.documentosVisibility == DocumentosVisibility.visivel
                        ? CQColors.iron100
                        : CQColors.white,
                border: Border.all(
                  color: CQColors.iron100,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Documentos',
                  overflow: TextOverflow.ellipsis,
                  style: CQTheme.h3.copyWith(
                    color: state.documentosVisibility ==
                            DocumentosVisibility.visivel
                        ? CQColors.white
                        : CQColors.iron100,
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<CadastrarCubit, CadastrarState>(builder: (context, state) {
          return Visibility(
            visible: state.documentosVisibility == DocumentosVisibility.visivel,
            child: Column(children: [
              CalendarPickerWidget(
                showAttachmentIcon: false,
                title: CQStrings.aso,
                isRequired: false,
                controller: asoController,
                onChanged: (time) => cubit.updateASO(time),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CalendarPickerWidget(
                      showAttachmentIcon: false,
                      title: CQStrings.nr34,
                      isRequired: false,
                      controller: nr34Controller,
                      onChanged: (time) => cubit.updateNR34(time),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: CalendarPickerWidget(
                      showAttachmentIcon: false,
                      title: CQStrings.nr10,
                      controller: nr10Controller,
                      onChanged: (time) => cubit.updateNR10(time),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CalendarPickerWidget(
                      showAttachmentIcon: false,
                      title: CQStrings.nr33,
                      controller: nr33Controller,
                      onChanged: (time) => cubit.updateNR33(time),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: CalendarPickerWidget(
                      showAttachmentIcon: false,
                      title: CQStrings.nr35,
                      controller: nr35Controller,
                      onChanged: (time) => cubit.updateNR35(time),
                    ),
                  ),
                ],
              ),
            ]),
          );
        })
      ],
      Divider(),
      Row(
        children: [
          Flexible(
            flex: 1,
            child: CalendarPickerWidget(
              showAttachmentIcon: false,
              title: CQStrings.dataInicial,
              isRequired: true,
              controller: dataInicialController,
              onChanged: (time) {
                cubit.updateDataInicial(time);
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: CalendarPickerWidget(
              showAttachmentIcon: false,
              title: CQStrings.dataLimite,
              isRequired: true,
              controller: dataFinalController,
              onChanged: (time) {
                cubit.updateDataLimite(time);
              },
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildVisitorHeader(CadastrarState state, CadastrarCubit cubit) {
    return Column(
      children: [
        TextInputWidget(
          title: CQStrings.liberadoPor,
          isRequired: true,
          controller: liberadoPorController,
          onChanged: (text) {
            cubit.updateLiberadoPor(
              text.toUpperCase(),
            );
          },
        ),
        TextInputWidget(
          title: CQStrings.nomedovisitante,
          isRequired: true,
          controller: nameVisitorController,
          onChanged: (text) {
            cubit.updateNome(
              text.toUpperCase(),
            );
          },
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextInputWidget(
                title: CQStrings.funcao,
                controller: roleController,
                onChanged: (text) {
                  cubit.updateFuncao(
                    text.toUpperCase(),
                  );
                },
                isRequired: true,
              ),
            ),
            Flexible(
              flex: 1,
              child: TextInputWidget(
                title: CQStrings.empresa,
                keyboardType: TextInputType.text,
                controller: companyController,
                onChanged: (text) {
                  cubit.updateEmpresa(
                    text.toUpperCase(),
                  );
                },
                isRequired: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserHeader(CadastrarState state, CadastrarCubit cubit) {
    return Column(
      children: [
        TextInputWidget(
          title: CQStrings.nome,
          isRequired: true,
          controller: nameUserController,
          onChanged: (text) {
            cubit.updateNome(
              text.toUpperCase(),
            );
          },
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextInputWidget(
                title: CQStrings.email,
                controller: emailController,
                onChanged: (text) {
                  cubit.updateEmail(
                    text.toUpperCase(),
                  );
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tipo sanguíneo', style: CQTheme.h2),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8, right: 16, bottom: 8),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11.5),
                        hintText: 'Tipo Sanguíneo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: CQColors.slate100,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: CQColors.slate100,
                            width: 1,
                          ),
                        ),
                      ),
                      value: state.user.bloodType,
                      onChanged: (String? newValue) {
                        cubit.updateBloodType(newValue ?? '');
                      },
                      items: [
                        '-',
                        'A+',
                        'A-',
                        'B+',
                        'B-',
                        'AB+',
                        'AB-',
                        'O+',
                        'O-',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextInputWidget(
                title: CQStrings.funcao,
                controller: roleController,
                onChanged: (text) {
                  cubit.updateFuncao(
                    text.toUpperCase(),
                  );
                },
                isRequired: true,
              ),
            ),
            Flexible(
              flex: 1,
              child: TextInputWidget(
                title: CQStrings.empresa,
                keyboardType: TextInputType.text,
                controller: companyController,
                onChanged: (text) {
                  cubit.updateEmpresa(
                    text.toUpperCase(),
                  );
                },
                isRequired: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(CadastrarState state, CadastrarCubit cubit) {
    return Container(
      color: CQColors.white,
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8, 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                cubit.reloadPage();
                clearFields();
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: CQColors.slate100),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Text(CQStrings.limpar,
                    overflow: TextOverflow.ellipsis, style: CQTheme.h3),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                if (state.cadastroHabilitado) {
                  state.copyWith(isLoading: true);
                  await cubit.createUser();
                  cubit.reloadPage();
                  clearFields();
                  state.copyWith(isLoading: false);
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: state.cadastroHabilitado
                      ? CQColors.iron100
                      : CQColors.iron30,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  CQStrings.cadastrarUpper,
                  overflow: TextOverflow.ellipsis,
                  style: CQTheme.h3.copyWith(color: CQColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
