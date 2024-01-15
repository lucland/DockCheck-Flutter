// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dockcheck/repositories/event_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as blue;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../models/event.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import '../../../utils/enums/beacon_button_enum.dart';
import 'cadastrar_state.dart';

class CadastrarCubit extends Cubit<CadastrarState> {
  final UserRepository userRepository;
  final EventRepository eventRepository;
  final LocalStorageService localStorageService;

  @override
  bool isClosed = false;
  String selectedBloodType = '';
  late StreamSubscription<List<blue.ScanResult>> scanSubscription;
  late Timer _scanTimer;

  CadastrarCubit(
      this.userRepository, this.eventRepository, this.localStorageService)
      : super(
          CadastrarState(
            numero: 0,
            isiTagValid: 'BUSCANDO BEACON...',
            user: User(
              id: '',
              authorizationsId: [""],
              name: '',
              company: '',
              role: '',
              project: '',
              number: 0,
              bloodType: '',
              cpf: '',
              aso: DateTime.now(),
              asoDocument: '',
              hasAso: false,
              nr34: DateTime.now(),
              nr34Document: '',
              hasNr34: false,
              nr35: DateTime.now(),
              nr35Document: '',
              hasNr35: false,
              nr33: DateTime.now(),
              nr33Document: '',
              hasNr33: false,
              nr10: DateTime.now(),
              nr10Document: '',
              hasNr10: false,
              email: '',
              area: 'Praça de Máquinas',
              isAdmin: false,
              isVisitor: false,
              isPortalo: false,
              isCrew: false,
              isOnboarded: false,
              isBlocked: false,
              blockReason: '',
              iTag: '',
              picture: '',
              typeJob: '',
              startJob: DateTime.now(),
              endJob: DateTime.now(),
              username: '',
              salt: '',
              hash: '',
              status: '',
            ),
            evento: Event(
              id: '',
              portalId: '',
              userId: '',
              timestamp: DateTime.now(),
              beaconId: '',
              vesselId: '',
              action: 0,
              justification: '',
              status: '',
            ),
          ),
        );

  void fetchNumero() async {
    if (!isClosed) {
      try {
        var numero = await userRepository.getLastUserNumber();
        final user = state.user.copyWith(number: numero);
        if (!isClosed) {
          emit(state.copyWith(user: user, isLoading: false, numero: numero));
        }
      } catch (e) {
        SimpleLogger.warning('Error during data synchronization: $e');
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ));
        }
      }
    }
  }

  void startScan() {
    const int searchDurationSeconds = 10;
    const int intervalBetweenScansSeconds = 5;

    Timer searchTimer;

    void scanDevices() {
      try {
        scanSubscription = blue.FlutterBluePlus.scanResults.listen(
          (List<blue.ScanResult> results) {
            try {
              var processedResults = _processScanResults(results);
              emit(state.copyWith(scanResults: processedResults));

              for (var result in results) {
                print(
                    'Device name: ${result.device.name}, ID: ${result.device.id}, RSSI: ${result.rssi}');
              }
            } catch (e) {
              print("Error processing scan results: $e");
            }
          },
        );

        blue.FlutterBluePlus.startScan();
        emit(state.copyWith(beaconButtonState: BeaconButtonState.Searching));

        searchTimer = Timer(Duration(seconds: searchDurationSeconds), () {
          stopScan();
          Timer(Duration(seconds: intervalBetweenScansSeconds), () {
            scanDevices();
          });
        });
      } catch (e) {
        print("Error starting scan: $e");
      }
    }

    scanDevices();
  }

  void resetBeacon() {
    try {
      emit(state.copyWith(
          selectedITagDevice: '',
          beaconButtonState: BeaconButtonState.Searching));
      startScan();
    } catch (e) {
      print("Error resetting beacon: $e");
    }
  }

  void stopScan() {
    try {
      blue.FlutterBluePlus.stopScan();
      scanSubscription.cancel();
      emit(state.copyWith(scanResults: []));
    } catch (e) {
      print("Error stopping scan: $e");
    }
  }

  void processScanResults(List<blue.ScanResult> results) {
    try {
      var processedResults = _processScanResults(results);

      if (processedResults.isNotEmpty) {
        var firstDeviceName = processedResults.first.device.advName;
        if (state.scanResults.isEmpty ||
            state.scanResults.first.device.advName != firstDeviceName) {
          userRepository.getValidITag(firstDeviceName).then((isValid) {
            var beaconButtonState = isValid
                ? BeaconButtonState.Register
                : BeaconButtonState.Invalid;
            emit(state.copyWith(
                scanResults: processedResults,
                beaconButtonState: beaconButtonState));
          });
        } else {
          emit(state.copyWith(scanResults: processedResults));
        }
      } else {
        emit(state.copyWith(
            scanResults: processedResults,
            beaconButtonState: BeaconButtonState.Searching));
      }
    } catch (e) {
      print("Error processing scan results: $e");
    }
  }

  void updateiTag(String itag) {
    try {
      final itagLowercase = itag.toLowerCase();
      final user = state.user.copyWith(iTag: itagLowercase);

      if (!isClosed) {
        emit(state.copyWith(user: user));
        checkCadastroHabilitado();
        print("ITAG DO USUÁRIO: $itagLowercase");
      }
    } catch (e) {
      print("Error updating iTag: $e");
    }
  }

  List<blue.ScanResult> _processScanResults(List<blue.ScanResult> results) {
    try {
      results = results.toSet().toList();
      results.sort((a, b) => b.rssi.compareTo(a.rssi));

      return results;
    } catch (e) {
      print("Error processing scan results: $e");
      return [];
    }
  }

  void updateLiberadoPor(String liberadoPor) {
    final user = state.user.copyWith(blockReason: liberadoPor);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final imagePath = image.path;
      updatePicture(imagePath);
    }
  }

  void updatePicture(String imagePath) {
    final user = state.user.copyWith(picture: imagePath);
    if (!isClosed) {
      emit(state.copyWith(user: user));
    }
  }

  void removeImage() {
    final user = state.user.copyWith(picture: '');
    emit(state.copyWith(user: user));
  }

  /*void updatePicture(Uint8List bytes) {
    // Convertendo bytes para string em base64
    String base64String = base64Encode(bytes);

    // Atualizando o estado com a nova imagem em base64
    final user = state.user.copyWith(picture: base64String);
    if (!isClosed) {
      emit(state.copyWith(user: user));
    }
  }*/

  /*(void removeImage() {
    // Logic to remove the image
    // Update the state with the new image
    final user = state.user.copyWith(picture: '');
    if (!isClosed) {
      emit(state.copyWith(user: user));
    }
  }*/

  void updateBloodType(String bloodType) {
    selectedBloodType = bloodType;
    final user = state.user.copyWith(bloodType: bloodType);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateNome(String nome) {
    final user = state.user.copyWith(name: nome, status: 'created');
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateFuncao(String funcao) {
    final user = state.user.copyWith(role: funcao);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateEmail(String email) {
    final user = state.user.copyWith(email: email);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateEmpresa(String empresa) {
    final user = state.user.copyWith(company: empresa);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void resetBeaconScan() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(isiTagValid: 'BUSCANDO BEACON...'));
  }

  void selectITagDevice(String deviceId) {
    emit(state.copyWith(selectedITagDevice: deviceId));
  }

  void updatePassword(String password) {
    final user = state.user.copyWith(salt: password, hash: '');
    if (!isClosed) {
      emit(state.copyWith(user: user));
    }
  }

  void updateUserVisitor(String usuario) {
    final user = state.user.copyWith(username: usuario);
    if (!isClosed) {
      emit(state.copyWith(user: user));
    }
  }

  void updateUserAdmin(String usuario) {
    final user = state.user.copyWith(username: usuario);
    if (!isClosed) {
      emit(state.copyWith(user: user));
    }
  }

  void updateDataInicial(DateTime dataInicial) {
    final user = state.user.copyWith(startJob: dataInicial);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateDataLimite(DateTime dataLimite) {
    final user = state.user.copyWith(endJob: dataLimite);
    checkCadastroHabilitado();
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateIsVisitante(bool isVisitante) {
    final user = state.user.copyWith(isVisitor: isVisitante);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateIsAdmin(bool isAdmin) {
    final user = state.user.copyWith(isAdmin: isAdmin);
    if (!isClosed) {}
    emit(state.copyWith(user: user));
  }

  void updateEventos(List<String> eventos) {
    final user = state.user.copyWith(events: eventos);
    if (!isClosed) {}
    emit(state.copyWith(user: user));
  }

  void updateCreatedAt(DateTime createdAt) {
    final user = state.user.copyWith(createdAt: createdAt);
    if (!isClosed) {}
    emit(state.copyWith(user: user));
  }

  void updateUpdatedAt(DateTime updatedAt) {
    final user = state.user.copyWith(updatedAt: updatedAt);
    if (!isClosed) {
      if (!isClosed) {}
      emit(state.copyWith(user: user));
    }
  }

  void updateIsBlocked(bool isBlocked) {
    final user = state.user.copyWith(isBlocked: isBlocked);
    if (!isClosed) {
      if (!isClosed) {}
      emit(state.copyWith(user: user));
    }
  }

  void updateArea(String area) {
    final user = state.user.copyWith(area: area);
    if (!isClosed) {
      if (!isClosed) {}
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void createEvent() async {
    //event vessel_id is the same as local storage vessel_id
    String vesselId = await localStorageService.getVesselId() ?? '';

    if (!isClosed) {
      if (!isClosed) {}
      emit(state.copyWith(
          isLoading: true,
          evento: state.evento.copyWith(
            timestamp: DateTime.now(),
            action: 3,
            vesselId: vesselId,
            portalId: '0',
            beaconId: '',
            status: 'created',
          )));
    }
    try {
      await eventRepository.createEvent(state.evento);
      clearFields();
      if (!isClosed) {
        if (!isClosed) {}
        emit(state.copyWith(isLoading: false, userCreated: true));
      }
    } catch (e) {
      SimpleLogger.warning('Error during cadastrar_cubit createEvent: $e');
      if (!isClosed) {
        if (!isClosed) {}
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void createUser() async {
    if (!isClosed) {}
    emit(state.copyWith(isLoading: true));
    final user = state.user.copyWith(id: Uuid().v1());
    emit(state.copyWith(user: user));
    try {
      await userRepository.createUser(state.user);
      createEvent();
    } catch (e) {
      SimpleLogger.warning('Error cadastrar_cubit createUser: $e');
      if (!isClosed) {
        if (!isClosed) {}
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void checkCadastroHabilitado() {
    if (state.user.isVisitor) {
      if (commonChecksPassed()) {
        if (!isClosed) {
          emit(state.copyWith(cadastroHabilitado: true));
        }
      } else {
        if (!isClosed) {
          emit(state.copyWith(cadastroHabilitado: false));
        }
      }
    } else if (!state.user.isAdmin) {
      if (commonChecksPassed()) {
        if (!isClosed) {
          emit(state.copyWith(cadastroHabilitado: true));
        }
      } else {
        if (!isClosed) {
          emit(state.copyWith(cadastroHabilitado: false));
        }
      }
    } else {
      if (adminCheckPassed()) {
        if (!isClosed) {
          emit(state.copyWith(cadastroHabilitado: true));
        }
      } else {
        if (!isClosed) {
          emit(state.copyWith(cadastroHabilitado: false));
        }
      }
    }
  }

  bool commonChecksPassed() {
    return state.user.name.isNotEmpty &&
        state.user.role.isNotEmpty &&
        state.user.company.isNotEmpty &&
        state.user.iTag.isNotEmpty &&
        state.user.picture.isNotEmpty &&
        state.user.endJob.isAfter(state.user.startJob);
  }

  bool adminCheckPassed() {
    return commonChecksPassed() && !state.user.isAdmin ||
        state.user.salt.isNotEmpty;
  }

  void clearFields() {
    final user = state.user.copyWith(
      id: '-',
      authorizationsId: ['-'],
      name: '-',
      company: '-',
      role: '-',
      project: '-',
      number: 0,
      bloodType: '-',
      cpf: '-',
      aso: DateTime.now(),
      asoDocument: '-',
      hasAso: false,
      nr34: DateTime.now(),
      nr34Document: '-',
      hasNr34: false,
      nr35: DateTime.now(),
      nr35Document: '-',
      hasNr35: false,
      nr33: DateTime.now(),
      nr33Document: '-',
      hasNr33: false,
      nr10: DateTime.now(),
      nr10Document: '-',
      hasNr10: false,
      email: '',
      area: '-',
      isAdmin: false,
      isVisitor: false,
      isPortalo: false,
      isOnboarded: false,
      isBlocked: false,
      blockReason: '-',
      iTag: '-',
      picture: '-',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      events: ['-'],
      typeJob: '-',
      startJob: DateTime.now(),
      endJob: DateTime.now(),
      username: '',
      salt: '',
      hash: '',
      status: '',
    );
    if (!isClosed) {}
    emit(state.copyWith(
      user: user,
      isLoading: false,
      evento: Event(
        id: '',
        portalId: '',
        userId: '',
        timestamp: DateTime.now(),
        vesselId: '',
        action: 0,
        justification: '',
        status: '',
        beaconId: '',
      ),
      userCreated: false,
      cadastroHabilitado: false,
    ));
  }

  @override
  Future<void> close() {
    // Cancel the stream subscription when the cubit is closed
    scanSubscription.cancel();
    return super.close();
  }
}
