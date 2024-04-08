import 'package:dockcheck/models/document.dart';

import '../../../models/event.dart';
import '../../../models/employee.dart';
import '../../../models/picture.dart';

class CadastrarState {
  final int numero;
  final Employee employee;
  final bool isLoading;
  final String? errorMessage;
  final Event event;
  final bool employeeCreated;
  final bool cadastroHabilitado;
  final List<String> nrTypes;
  final List<Document> documents;
  final Picture picture;
  final String selectedNr;

  CadastrarState({
    this.numero = 0,
    required this.employee,
    this.isLoading = true,
    this.errorMessage,
    required this.event,
    this.employeeCreated = false,
    this.cadastroHabilitado = false,
    this.nrTypes = const [],
    this.documents = const [],
    required this.picture,
    this.selectedNr = '',
  });

  CadastrarState copyWith({
    int? numero,
    Employee? employee,
    bool? isLoading,
    String? errorMessage,
    Event? event,
    bool? employeeCreated,
    bool? cadastroHabilitado,
    List<String>? nrTypes,
    List<Document>? documents,
    Picture? picture,
    String? selectedNr,
  }) {
    return CadastrarState(
      numero: numero ?? this.numero,
      employee: employee ?? this.employee,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      event: event ?? this.event,
      employeeCreated: employeeCreated ?? this.employeeCreated,
      cadastroHabilitado: cadastroHabilitado ?? this.cadastroHabilitado,
      nrTypes: nrTypes ?? this.nrTypes,
      documents: documents ?? this.documents,
      picture: picture ?? this.picture,
      selectedNr: selectedNr ?? this.selectedNr,
    );
  }
}
