import 'package:cripto_qr_googlemarine/models/evento.dart';

import '../../../models/user.dart';

class EditarState {
  final int numero;
  final User user;
  final bool isLoading;
  final String? errorMessage;
  final Evento evento;
  final bool userCreated;
  final bool cadastroHabilitado;

  EditarState({
    this.numero = 0,
    required this.user,
    this.isLoading = true,
    this.errorMessage,
    required this.evento,
    this.userCreated = false,
    this.cadastroHabilitado = true,
  });

  EditarState copyWith({
    int? numero,
    User? user,
    bool? isLoading,
    String? errorMessage,
    Evento? evento,
    bool? userCreated,
    bool? cadastroHabilitado,
  }) {
    return EditarState(
      numero: numero ?? this.numero,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      evento: evento ?? this.evento,
      userCreated: userCreated ?? this.userCreated,
      cadastroHabilitado: cadastroHabilitado ?? this.cadastroHabilitado,
    );
  }
}
