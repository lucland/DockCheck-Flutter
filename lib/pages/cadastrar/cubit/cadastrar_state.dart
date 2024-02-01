import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/pages/cadastrar/cubit/doc_enum.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../../models/user.dart';
import '../../../utils/enums/beacon_button_enum.dart';

class CadastrarState {
  final int numero;
  final User user;
  final bool isLoading;
  final String? errorMessage;
  final Event evento;
  final bool userCreated;
  final bool cadastroHabilitado;
  final String selectedITagDevice;
  final String isiTagValid;
  final String lastDeviceId;
  final List<DiscoveredDevice> scanResults;
  final DiscoveredDevice? scanResult;
  final DocumentosVisibility documentosVisibility;
  final BeaconButtonState beaconButtonState;

  CadastrarState({
    this.numero = 0,
    required this.user,
    this.isLoading = true,
    this.errorMessage,
    required this.evento,
    this.userCreated = false,
    this.cadastroHabilitado = false,
    this.selectedITagDevice = '',
    this.isiTagValid = '',
    this.lastDeviceId = '',
    this.scanResults = const [],
    this.beaconButtonState = BeaconButtonState.Searching,
    required this.documentosVisibility,
    this.scanResult,
  });

  CadastrarState copyWith({
    int? numero,
    User? user,
    bool? isLoading,
    String? errorMessage,
    Event? evento,
    bool? userCreated,
    bool? cadastroHabilitado,
    String? selectedITagDevice,
    String? isiTagValid,
    String? lastDeviceId,
    List<DiscoveredDevice>? scanResults,
    DiscoveredDevice? scanResult,
    DocumentosVisibility? documentosVisibility,
    BeaconButtonState? beaconButtonState,
  }) {
    return CadastrarState(
      numero: numero ?? this.numero,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      evento: evento ?? this.evento,
      userCreated: userCreated ?? this.userCreated,
      cadastroHabilitado: cadastroHabilitado ?? this.cadastroHabilitado,
      selectedITagDevice: selectedITagDevice ?? this.selectedITagDevice,
      isiTagValid: isiTagValid ?? this.isiTagValid,
      lastDeviceId: lastDeviceId ?? this.lastDeviceId,
      scanResults: scanResults ?? this.scanResults,
      beaconButtonState: beaconButtonState ?? this.beaconButtonState,
      documentosVisibility: documentosVisibility ?? this.documentosVisibility,
      scanResult: scanResult,
    );
  }
}
