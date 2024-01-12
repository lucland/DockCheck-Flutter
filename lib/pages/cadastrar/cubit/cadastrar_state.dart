import 'package:dockcheck/models/event.dart';

import '../../../models/user.dart';

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
    );
  }
}
