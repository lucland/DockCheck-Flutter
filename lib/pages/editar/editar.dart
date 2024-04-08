/*import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_state.dart';
import 'package:dockcheck/repositories/event_repository.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/widgets/bluetooth_scan_button_widget.dart';
import 'package:dockcheck/widgets/switcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import '../../utils/theme.dart';
import '../../utils/ui/colors.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/calendar_picker_widget.dart';
import '../../widgets/text_input_widget.dart';
import 'cubit/editar_cubit.dart';
import 'cubit/editar_state.dart';

class Editar extends StatefulWidget {
  final VoidCallback onSalvar;
  final User user;
  const Editar({super.key, required this.onSalvar, required this.user});

  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  @override
  void initState() {
    super.initState();
    //context.read<CadastrarCubit>().startScan();
  }

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    final EventRepository eventRepository =
        Provider.of<EventRepository>(context);

    return BlocProvider(
      create: (context) =>
          EditarCubit(userRepository, widget.user, eventRepository),
      child: EditarView(
        onSalvar: widget.onSalvar,
        user: widget.user,
      ),
    );
  }
}

Widget _buildBluetoothScanSection(BuildContext context, CadastrarState state) {
  final CadastrarCubit cubit = context.read<CadastrarCubit>();

  return BluetoothScanButton(
    cubit: cubit,
  );
}

class EditarView extends StatelessWidget {
  final VoidCallback onSalvar;
  final User user;
  const EditarView({super.key, required this.onSalvar, required this.user});

  @override
  Widget build(BuildContext context) {
    final TextEditingController identidadeController =
        TextEditingController(text: Formatter.identidade(user.bloodType));
    final TextEditingController nomeController =
        TextEditingController(text: user.name);
    final TextEditingController funcaoController =
        TextEditingController(text: user.role);
    //TODO: alterar
    //final TextEditingController empresaController = TextEditingController(text: user.company);
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    //TODO: senhaController
    /*final TextEditingController senhaController =
        TextEditingController(text: user.name);
    final TextEditingController asoController =
        TextEditingController(text: Formatter.formatDateTime(user.aso));
    final TextEditingController nr34Controller =
        TextEditingController(text: Formatter.formatDateTime(user.nr34));
    final TextEditingController nr10Controller =
        TextEditingController(text: Formatter.formatDateTime(user.nr10));
    final TextEditingController nr33Controller =
        TextEditingController(text: Formatter.formatDateTime(user.nr33));
    final TextEditingController nr35Controller =
        TextEditingController(text: Formatter.formatDateTime(user.nr35));*/
    final TextEditingController dataInicialController =
        TextEditingController(text: Formatter.formatDateTime(DateTime.now()));
    final TextEditingController dataFinalController =
        TextEditingController(text: Formatter.formatDateTime(DateTime.now()));

    return BlocConsumer<EditarCubit, EditarState>(listener: (context, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.errorMessage!,
              style: CQTheme.body.copyWith(color: CQColors.white),
            ),
            backgroundColor: CQColors.danger100,
          ),
        );
      }
      if (state.userCreated) {
        identidadeController.clear();
        nomeController.clear();
        funcaoController.clear();

        emailController.clear();

        dataInicialController.clear();
        dataFinalController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              CQStrings.usuarioEditadoComSucesso,
              style: CQTheme.body.copyWith(color: CQColors.white),
            ),
            backgroundColor: CQColors.success100,
          ),
        );
        context.read<EditarCubit>().clearFields();
        onSalvar();
      }
    }, builder: (context, state) {
      final cubit = context.read<EditarCubit>();

      if (state.isLoading) {
        context.read<EditarCubit>().originalUserData(user);
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      } else {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: CQColors.iron100,
            elevation: 0,
            title: const Text(CQStrings.informacoes,
                style: CQTheme.h2, overflow: TextOverflow.ellipsis),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: CQColors.white,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('N° ${state.user.number}', style: CQTheme.h1),
                          const Divider(),
                          BluetoothScanButton(cubit: context.read()),
                          TextInputWidget(
                            title: CQStrings.nome,
                            isRequired: true,
                            controller: nomeController,
                            onChanged: (text) => cubit.updateNome(text),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextInputWidget(
                                  title: CQStrings.email,
                                  controller: emailController,
                                  onChanged: (text) => cubit.updateEmail(text),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tipo sanguíneo', style: CQTheme.h2),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 8, right: 16, bottom: 8),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 11.5),
                                          hintText: 'Tipo Sanguíneo',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: CQColors.slate100,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: CQColors.slate100,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        value: cubit.selectedBloodType,
                                        onChanged: (String? newValue) {
                                          cubit.updateBloodType(newValue ?? '');
                                        },
                                        items: [
                                          '',
                                          'A+',
                                          'A-',
                                          'B+',
                                          'B-',
                                          'AB+',
                                          'AB-',
                                          'O+',
                                          'O-',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                  controller: funcaoController,
                                  onChanged: (text) => cubit.updateFuncao(text),
                                  isRequired: true,
                                ),
                              ),
                              //TODO: alterar
                              /*Flexible(
                                flex: 1,
                                child: TextInputWidget(
                                  title: CQStrings.empresa,
                                  keyboardType: TextInputType.text,
                                  controller: empresaController,
                                  onChanged: (text) =>
                                      cubit.updateEmpresa(text),
                                  isRequired: true,
                                ),
                              ),*/
                            ],
                          ),
                          /*
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              CQStrings.embarcacao,
                              style: CQTheme.h2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: CQColors.iron100,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: state.user.vessel != ''
                                      ? state.user.vessel
                                      : 'SKANDI AMAZONAS',
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: CQColors.iron100,
                                  ),
                                  iconSize: 32,
                                  alignment: Alignment.centerRight,
                                  elevation: 2,
                                  style: CQTheme.h2.copyWith(
                                    color: CQColors.iron100,
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return <String>[
                                      'SKANDI AMAZONAS',
                                      'SKANDI IGUAÇU',
                                      'SKANDI FLUMINENSE',
                                      'SKANDI URCA'
                                    ].map<Widget>((String value) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          value,
                                          style: CQTheme.h2.copyWith(
                                            color: CQColors.iron100,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onChanged: (String? newValue) {
                                    cubit.updateVessel(newValue!);
                                  },
                                  underline: Container(
                                    height: 0,
                                    color: CQColors.iron100,
                                  ),
                                  items: <String>[
                                    'SKANDI AMAZONAS',
                                    'SKANDI IGUAÇU',
                                    'SKANDI FLUMINENSE',
                                    'SKANDI URCA'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),*/
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 16.0, 16, 0.0),
                            child: Text(
                              CQStrings.area,
                              style: CQTheme.h2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const Divider(),

                          const Divider(),

                          const Divider(),
                          //TODO: alterar
                          /*Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: CalendarPickerWidget(
                                  title: CQStrings.dataInicial,
                                  isRequired: true,
                                  controller: dataInicialController,
                                  onChanged: (time) =>
                                      cubit.updateDataInicial(time),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: CalendarPickerWidget(
                                  title: CQStrings.dataLimite,
                                  isRequired: true,
                                  controller: dataFinalController,
                                  onChanged: (time) =>
                                      cubit.updateDataLimite(time),
                                ),
                              ),
                            ],
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: CQColors.white,
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8, 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          identidadeController.clear();
                          nomeController.clear();
                          funcaoController.clear();

                          emailController.clear();

                          dataInicialController.clear();
                          dataFinalController.clear();

                          cubit.clearFields();
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
                              overflow: TextOverflow.ellipsis,
                              style: CQTheme.h3),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          cubit.createEvent();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: CQColors.iron100,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            CQStrings.salvar,
                            overflow: TextOverflow.ellipsis,
                            style: CQTheme.h3.copyWith(color: CQColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
*/