import 'dart:async';
import 'dart:io';

import 'package:dockcheck/repositories/event_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/widgets/switcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as blue;
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../repositories/user_repository.dart';
import '../../utils/theme.dart';
import '../../utils/ui/colors.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/calendar_picker_widget.dart';
import '../../widgets/text_input_widget.dart';
import 'cubit/cadastrar_cubit.dart';
import 'cubit/cadastrar_state.dart';

class Cadastrar extends StatefulWidget {
  final VoidCallback onCadastrar;
  const Cadastrar({super.key, required this.onCadastrar});

  @override
  State<Cadastrar> createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    final EventRepository eventRepository =
        Provider.of<EventRepository>(context);
    final LocalStorageService localStorageService =
        Provider.of<LocalStorageService>(context);

    return BlocProvider(
      create: (context) =>
          CadastrarCubit(userRepository, eventRepository, localStorageService),
      child: CadastrarView(
        onCadastrar: widget.onCadastrar,
      ),
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
  List<blue.ScanResult> scanResults = [];
  late StreamSubscription<List<blue.ScanResult>> scanSubscription;
  int maxDistance = -49;
  XFile? _pickedImage;
  bool _hasImage = false;
  String searchingBeaconc = '';
  bool documentosAbertos = false;
  bool isVisitor = false;
  bool isntRegistered = true;
  late Timer scanTimer;
  String lastDeviceId = '';

// ----- nnnnnndesacoplar -------

  void startScan() {
    scanSubscription = blue.FlutterBluePlus.scanResults.listen(
      (List<blue.ScanResult> results) {
        setState(() {
          results = results
              .where((result) =>
                  result.device.name?.toLowerCase().startsWith('itag') ==
                      true &&
                  result.rssi >= maxDistance)
              .toList();

          results.sort((a, b) => b.rssi.compareTo(a.rssi));
          scanResults = results.take(1).toList();
          if (scanResults.length > 0) {
            lastDeviceId =
                scanResults[0].device.remoteId.toString().toLowerCase() ?? '';
          }
        });
      },
    );

    blue.FlutterBluePlus.startScan();
  }

  void stopScan() {
    blue.FlutterBluePlus.stopScan();
    scanSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    startScan();
/*
    scanTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      stopScan();
      startScan();
      Timer(Duration(seconds: 5), () {
        stopScan();
      });
    });
    */
  }

  @override
  void dispose() {
    stopScan();
    scanTimer.cancel();
    super.dispose();
  }

  Future<void> _escolherImagemDaGaleria() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _hasImage = true;
        _pickedImage = pickedFile;
        Navigator.pop(context);
        mostrarPopupFoto(context);
      });
    }
  }

  Future<void> _tirarFoto() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _hasImage = true;
        _pickedImage = pickedFile;
        Navigator.pop(context);
        mostrarPopupFoto(context);
      });
    }
  }

  void _removerFoto() {
    setState(() {
      _hasImage = false;
      _pickedImage = null;
      Navigator.pop(context);
      mostrarPopupFoto(context);
    });
  }

  void mostrarPopupFoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 120, vertical: 20),
          backgroundColor: CQColors.white, // cor do fundo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Identidade',
                      style: CQTheme.h2,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Adicione o seu documento aqui',
                      style: CQTheme.body2,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    height: 300,
                    color: Colors.transparent, // Fundo da foto
                    child: _pickedImage != null
                        ? Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.cover,
                          )
                        : GestureDetector(
                            onTap: () async {
                              await _tirarFoto();
                            },
                            child: Center(
                              child: Image.asset(
                                'assets/imgs/rg2.2.png',
                                fit: BoxFit.cover,
                                height: 400,
                                width: 400,
                              ),
                            ),
                          ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (_hasImage == false) {
                            await _tirarFoto();
                          } else
                            _removerFoto();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: CQColors.iron100),
                              color: CQColors.iron100,
                            ),
                            child: Center(
                              child: Text(
                                _hasImage
                                    ? 'Remover credencial'
                                    : 'Adicionar credencial',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: CQColors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: CQColors.iron100),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                'Salvar',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: CQColors.iron100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------ yyyyy desacoplar
  @override
  Widget build(BuildContext context) {
    final TextEditingController identidadeController = TextEditingController();
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController funcaoController = TextEditingController();
    final TextEditingController empresaController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usuarioController = TextEditingController();
    final TextEditingController visitorController = TextEditingController();
    final TextEditingController itagController = TextEditingController();
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
        widget.onCadastrar();
      }
      if (lastDeviceId.isNotEmpty &&
          state.lastDeviceId.toLowerCase() != lastDeviceId.toLowerCase()) {
        context.read<CadastrarCubit>().checkiTag(lastDeviceId.toLowerCase());
      }
      if (state.isiTagValid == 'BEACON JÁ POSSUI USUÁRIO VINCULADO') {
        print('BEACON JÁ POSSUI USUÁRIO VINCULADO');
        context.read<CadastrarCubit>().resetBeaconScan();
        if (scanSubscription.isPaused) {
          startScan();
        }
      } else if (state.isiTagValid == 'REGISTRAR BEACON') {
        stopScan();
      } else {
        if (scanSubscription.isPaused) {
          startScan();
        }
      }
    }, builder: (context, state) {
      final cubit = context.read<CadastrarCubit>();
      if (state.isLoading) {
        context.read<CadastrarCubit>().fetchNumero();
        return const Center(child: CircularProgressIndicator());
      } else {
        if (lastDeviceId.isNotEmpty &&
            state.lastDeviceId.toLowerCase() != lastDeviceId.toLowerCase()) {
          cubit.checkiTag(lastDeviceId.toLowerCase());
        }
        isVisitor = state.user.isVisitor;
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
                                  state.user.isVisitor
                                      ? cubit.updateIsVisitante(false)
                                      : cubit.updateIsVisitante(true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            cubit.updateIsVisitante(
                                                !state.user.isVisitor);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: 8.0, left: 8),
                                            decoration: BoxDecoration(
                                              color: isVisitor
                                                  ? CQColors.iron100
                                                  : CQColors.white,
                                              border: Border.all(
                                                  color: !isVisitor
                                                      ? CQColors.iron100
                                                      : CQColors.white),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(CQStrings.visitante,
                                                overflow: TextOverflow.ellipsis,
                                                style: CQTheme.h3.copyWith(
                                                    color: !isVisitor
                                                        ? CQColors.iron100
                                                        : CQColors.white)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            cubit.updateIsVisitante(false);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: 8.0),
                                            decoration: BoxDecoration(
                                              color: !isVisitor
                                                  ? CQColors.iron100
                                                  : CQColors.white,
                                              border: Border.all(
                                                  color: isVisitor
                                                      ? CQColors.iron100
                                                      : CQColors.white),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(CQStrings.usuario,
                                                overflow: TextOverflow.ellipsis,
                                                style: CQTheme.h3.copyWith(
                                                    color: isVisitor
                                                        ? CQColors.iron100
                                                        : CQColors.white)),
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
                        Column(
                          children: [
                            if (state.user.isVisitor) ...[
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 0, 16, 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (isntRegistered ||
                                                scanResults.isEmpty)
                                            ? CQColors.iron100
                                            : CQColors.danger100,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: (isntRegistered ||
                                                  scanResults.isEmpty)
                                              ? CQColors.iron100
                                              : CQColors.danger100,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: !(scanResults.isEmpty &&
                                                isntRegistered),
                                            child: Container(
                                              height: 60,
                                              child: ListView.builder(
                                                itemCount: scanResults.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Center(
                                                      child: Text(
                                                        state.isiTagValid,
                                                        style:
                                                            CQTheme.h1.copyWith(
                                                          color: isntRegistered
                                                              ? CQColors.white
                                                              : CQColors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        isntRegistered =
                                                            !isntRegistered;

                                                        if (!isntRegistered) {
                                                          lastDeviceId =
                                                              scanResults[index]
                                                                  .device
                                                                  .id
                                                                  .toString()
                                                                  .toLowerCase();
                                                          stopScan();
                                                          scanTimer.cancel();
                                                          print(
                                                              'Último ID armazenado: $lastDeviceId');
                                                          return;
                                                        }

                                                        if (isntRegistered) {
                                                          setState(() {
                                                            startScan();

                                                            scanTimer =
                                                                Timer.periodic(
                                                                    Duration(
                                                                        seconds:
                                                                            10),
                                                                    (Timer
                                                                        timer) {
                                                              stopScan();
                                                              startScan();
                                                              Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          5),
                                                                  () {
                                                                stopScan();
                                                              });
                                                            });
                                                          });
                                                        }

                                                        context
                                                            .read<
                                                                CadastrarCubit>()
                                                            .selectITagDevice(
                                                              scanResults
                                                                      .isEmpty
                                                                  ? lastDeviceId
                                                                      .toLowerCase()
                                                                  : scanResults[
                                                                          index]
                                                                      .device
                                                                      .id
                                                                      .toString()
                                                                      .toLowerCase(),
                                                            );
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: scanResults.isEmpty &&
                                                isntRegistered,
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: CQColors.iron100,
                                                  width:
                                                      1.0, // Ajuste a largura da borda conforme necessário
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'BUSCANDO BEACON',
                                                  style: CQTheme.h1.copyWith(
                                                      color: CQColors.iron100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextInputWidget(
                                      title: CQStrings.liberadoPor,
                                      isRequired: true,
                                      controller: visitorController,
                                      onChanged: (text) {}),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: Column(
                                          children: [
                                            TextInputWidget(
                                              title: CQStrings.nomedovisitante,
                                              isRequired: true,
                                              controller: nomeController,
                                              onChanged: (text) =>
                                                  cubit.updateNome(text),
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: TextInputWidget(
                                                    title: CQStrings.funcao,
                                                    controller:
                                                        funcaoController,
                                                    onChanged: (text) => cubit
                                                        .updateFuncao(text),
                                                    isRequired: true,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: TextInputWidget(
                                                    title: CQStrings.empresa,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        empresaController,
                                                    onChanged: (text) => cubit
                                                        .updateEmpresa(text),
                                                    isRequired: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            mostrarPopupFoto(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 16,
                                              bottom: 8,
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              child: _pickedImage != null
                                                  ? Image.file(
                                                      File(_pickedImage!.path),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Center(
                                                      child: Icon(
                                                        Icons
                                                            .document_scanner_outlined,
                                                        color: CQColors.iron80,
                                                        size: 45,
                                                      ),
                                                    ),
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: _hasImage
                                                      ? Colors.transparent
                                                      : CQColors.iron80,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        Column(
                          children: [
                            if (!state.user.isVisitor) ...[
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 0, 16, 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (isntRegistered ||
                                                scanResults.isEmpty)
                                            ? CQColors.iron100
                                            : CQColors.danger100,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: (isntRegistered ||
                                                  scanResults.isEmpty)
                                              ? CQColors.iron100
                                              : CQColors.danger100,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: !(scanResults.isEmpty &&
                                                isntRegistered),
                                            child: Container(
                                              height: 60,
                                              child: ListView.builder(
                                                itemCount: scanResults.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Center(
                                                      child: Text(
                                                        state.isiTagValid,
                                                        style:
                                                            CQTheme.h1.copyWith(
                                                          color: isntRegistered
                                                              ? CQColors.white
                                                              : CQColors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        isntRegistered =
                                                            !isntRegistered;

                                                        if (!isntRegistered) {
                                                          lastDeviceId =
                                                              scanResults[index]
                                                                  .device
                                                                  .id
                                                                  .toString()
                                                                  .toLowerCase();
                                                          stopScan();
                                                          scanTimer.cancel();
                                                          print(
                                                              'Último ID armazenado: $lastDeviceId');
                                                          return;
                                                        }

                                                        if (isntRegistered) {
                                                          setState(() {
                                                            startScan();

                                                            scanTimer =
                                                                Timer.periodic(
                                                                    Duration(
                                                                        seconds:
                                                                            10),
                                                                    (Timer
                                                                        timer) {
                                                              stopScan();
                                                              startScan();
                                                              Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          5),
                                                                  () {
                                                                stopScan();
                                                              });
                                                            });
                                                          });
                                                        }

                                                        context
                                                            .read<
                                                                CadastrarCubit>()
                                                            .selectITagDevice(
                                                              scanResults
                                                                      .isEmpty
                                                                  ? lastDeviceId
                                                                      .toLowerCase()
                                                                  : scanResults[
                                                                          index]
                                                                      .device
                                                                      .id
                                                                      .toString()
                                                                      .toLowerCase(),
                                                            );
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: scanResults.isEmpty &&
                                                isntRegistered,
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: CQColors.iron100,
                                                  width:
                                                      1.0, // Ajuste a largura da borda conforme necessário
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'BUSCANDO BEACON',
                                                  style: CQTheme.h1.copyWith(
                                                      color: CQColors.iron100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: Column(
                                            children: [
                                              TextInputWidget(
                                                title: CQStrings.nome,
                                                isRequired: true,
                                                controller: nomeController,
                                                onChanged: (text) =>
                                                    cubit.updateNome(text),
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    child: TextInputWidget(
                                                      title: CQStrings.email,
                                                      controller:
                                                          emailController,
                                                      onChanged: (text) => cubit
                                                          .updateEmail(text),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Tipo sanguíneo',
                                                            style: CQTheme.h2),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8,
                                                                  right: 16,
                                                                  bottom: 8),
                                                          child:
                                                              DropdownButtonFormField<
                                                                  String>(
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          11.5),
                                                              hintText:
                                                                  'Tipo Sanguíneo',
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: CQColors
                                                                      .slate100,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: CQColors
                                                                      .slate100,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                            ),
                                                            value: cubit
                                                                .selectedBloodType,
                                                            onChanged: (String?
                                                                newValue) {
                                                              cubit.updateBloodType(
                                                                  newValue ??
                                                                      '');
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
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
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
                                      Flexible(
                                        flex: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            mostrarPopupFoto(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 16, bottom: 8),
                                            child: Container(
                                              width: double.maxFinite,
                                              height: 250,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: _hasImage
                                                      ? Colors.transparent
                                                      : CQColors.iron80,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: _pickedImage != null
                                                    ? Image.file(
                                                        File(
                                                            _pickedImage!.path),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Center(
                                                        child: Icon(
                                                          Icons
                                                              .document_scanner_outlined,
                                                          color:
                                                              CQColors.iron80,
                                                          size: 45,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                      onChanged: (text) =>
                                          cubit.updateFuncao(text),
                                      isRequired: true,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: TextInputWidget(
                                      title: CQStrings.empresa,
                                      keyboardType: TextInputType.text,
                                      controller: empresaController,
                                      onChanged: (text) =>
                                          cubit.updateEmpresa(text),
                                      isRequired: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
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
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 8.0, 8, 16.0),
                                child: SwitcherWidget(
                                    onTap: (txt) => cubit.updateArea(txt),
                                    activeArea: state.user.area),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: CalendarPickerWidget(
                                      showAttachmentIcon: false,
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
                                      showAttachmentIcon: false,
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
                        if (state.cadastroHabilitado &&
                            lastDeviceId.isNotEmpty) {
                          cubit.updateiTag(lastDeviceId);
                          cubit.createUser();
                          print('Cadastrado com sucesso => dados + beacon');
                          //apagar a foto depois de criar o usuário
                          lastDeviceId = '';
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
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                CQStrings.embarcacao,
                style: CQTheme.h2,
              ),
            ),
          ],
        );
      }
    });
  }
}
