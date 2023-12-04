import 'package:cripto_qr_googlemarine/repositories/event_repository.dart';
import 'package:cripto_qr_googlemarine/utils/formatter.dart';
import 'package:cripto_qr_googlemarine/widgets/switcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
  const Cadastrar({super.key, required this.onCadastrar});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    final EventRepository eventRepository =
        Provider.of<EventRepository>(context);

    return BlocProvider(
      create: (context) => CadastrarCubit(userRepository, eventRepository),
      child: CadastrarView(
        onCadastrar: onCadastrar,
      ),
    );
  }
}

class CadastrarView extends StatelessWidget {
  final VoidCallback onCadastrar;
  const CadastrarView({super.key, required this.onCadastrar});

  @override
  Widget build(BuildContext context) {
    final TextEditingController identidadeController = TextEditingController();
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController funcaoController = TextEditingController();
    final TextEditingController empresaController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();
    final TextEditingController asoController = TextEditingController();
    final TextEditingController nr34Controller = TextEditingController();
    final TextEditingController nr10Controller = TextEditingController();
    final TextEditingController nr33Controller = TextEditingController();
    final TextEditingController nr35Controller = TextEditingController();
    final TextEditingController dataInicialController =
        TextEditingController(text: Formatter.formatDateTime(DateTime.now()));
    final TextEditingController dataFinalController =
        TextEditingController(text: Formatter.formatDateTime(DateTime.now()));

    return BlocConsumer<CadastrarCubit, CadastrarState>(
        listener: (context, state) {
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
        empresaController.clear();
        emailController.clear();
        asoController.clear();
        nr34Controller.clear();
        nr10Controller.clear();
        nr33Controller.clear();
        nr35Controller.clear();
        dataInicialController.clear();
        dataFinalController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              CQStrings.usuarioCadastradoComSucesso,
              style: CQTheme.body.copyWith(color: CQColors.white),
            ),
            backgroundColor: CQColors.success100,
          ),
        );
        context.read<CadastrarCubit>().clearFields();
        //ir para a home page
        onCadastrar();
      }
    }, builder: (context, state) {
      final cubit = context.read<CadastrarCubit>();
      if (state.isLoading) {
        context.read<CadastrarCubit>().fetchNumero();
        return const Center(child: CircularProgressIndicator());
      } else {
        return Column(
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
                              child: TextInputWidget(
                                title: CQStrings.identidade,
                                keyboardType: TextInputType.number,
                                controller: identidadeController,
                                onChanged: (text) => cubit.updateIdentidade(
                                  text.replaceAll('.', '').replaceAll('-', ''),
                                ),
                                isRequired: true,
                                isID: true,
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
                            Flexible(
                              flex: 1,
                              child: TextInputWidget(
                                title: CQStrings.empresaTrip,
                                keyboardType: TextInputType.text,
                                controller: empresaController,
                                onChanged: (text) => cubit.updateEmpresa(text),
                                isRequired: true,
                              ),
                            ),
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
                                ].map<DropdownMenuItem<String>>((String value) {
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
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 8, 16.0),
                          child: SwitcherWidget(
                              onTap: (txt) => cubit.updateArea(txt),
                              activeArea: state.user.area),
                        ),
                        const Divider(),
                        CalendarPickerWidget(
                          title: CQStrings.aso,
                          isRequired: true,
                          controller: asoController,
                          onChanged: (time) => cubit.updateASO(time),
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: CalendarPickerWidget(
                                title: CQStrings.nr34,
                                isRequired: true,
                                controller: nr34Controller,
                                onChanged: (time) => cubit.updateNR34(time),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: CalendarPickerWidget(
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
                                title: CQStrings.nr33,
                                controller: nr33Controller,
                                onChanged: (time) => cubit.updateNR33(time),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: CalendarPickerWidget(
                                title: CQStrings.nr35,
                                controller: nr35Controller,
                                onChanged: (time) => cubit.updateNR35(time),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  state.user.isVisitor
                                      ? cubit.updateIsVisitante(false)
                                      : cubit.updateIsVisitante(true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 8.0, 0, 8.0),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          CQStrings.visitante,
                                          style: CQTheme.h2,
                                        ),
                                      ),
                                      Checkbox(
                                        value: state.user.isVisitor,
                                        onChanged: (value) {
                                          state.user.isVisitor
                                              ? cubit.updateIsVisitante(false)
                                              : cubit.updateIsVisitante(true);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 30.0,
                              width: 1.0,
                              color: CQColors.iron30,
                              margin:
                                  const EdgeInsets.only(left: 12.0, right: 2.0),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  state.user.isAdmin
                                      ? cubit.updateIsAdmin(false)
                                      : cubit.updateIsAdmin(true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          CQStrings.admin,
                                          style: CQTheme.h2,
                                        ),
                                      ),
                                      Checkbox(
                                        value: state.user.isAdmin,
                                        onChanged: (value) {
                                          state.user.isAdmin
                                              ? cubit.updateIsAdmin(false)
                                              : cubit.updateIsAdmin(true);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.user.isAdmin)
                          TextInputWidget(
                            title: CQStrings.senha,
                            isRequired: true,
                            controller: senhaController,
                            onChanged: (text) => cubit.updatePassword(text),
                          ),
                        const Divider(),
                        Row(
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
                        ),
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
                        empresaController.clear();
                        emailController.clear();
                        asoController.clear();
                        nr34Controller.clear();
                        nr10Controller.clear();
                        nr33Controller.clear();
                        nr35Controller.clear();
                        dataInicialController.clear();
                        dataFinalController.clear();
                        senhaController.clear();
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
                            overflow: TextOverflow.ellipsis, style: CQTheme.h3),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        state.cadastroHabilitado ? cubit.createEvent() : null;
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
            ),
          ],
        );
      }
    });
  }
}
