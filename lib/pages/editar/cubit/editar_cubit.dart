import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/repositories/event_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import 'editar_state.dart';

class EditarCubit extends Cubit<EditarState> {
  final UserRepository userRepository;
  final EventRepository eventRepository;
  final User originalUser;
  String selectedBloodType = '';

  EditarCubit(this.userRepository, this.originalUser, this.eventRepository)
      : super(
          EditarState(
            numero: 0,
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
              id: Uuid().v4(),
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

  void originalUserData(User userr) async {
    await Future.delayed(Duration(milliseconds: 500));
    emit(state.copyWith(user: userr, isLoading: false, numero: userr.number));
  }

  void updateBloodType(String bloodType) {
    selectedBloodType = bloodType;
    final user = state.user.copyWith(bloodType: bloodType);
    if (!isClosed) {
      emit(state.copyWith(user: user));
      checkCadastroHabilitado();
    }
  }

  void updateNome(String nome) {
    final user = state.user.copyWith(name: nome);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateFuncao(String funcao) {
    final user = state.user.copyWith(role: funcao);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateEmail(String email) {
    final user = state.user.copyWith(email: email);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateEmpresa(String empresa) {
    final user = state.user.copyWith(company: empresa);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateASO(DateTime ASO) {
    final user = state.user.copyWith(aso: ASO);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateNR34(DateTime NR34) {
    final user = state.user.copyWith(nr34: NR34);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateNR10(DateTime NR10) {
    final user = state.user.copyWith(nr10: NR10);
    emit(state.copyWith(user: user));
  }

  void updateNR33(DateTime NR33) {
    final user = state.user.copyWith(nr33: NR33);
    emit(state.copyWith(user: user));
  }

  void updateNR35(DateTime NR35) {
    final user = state.user.copyWith(nr35: NR35);
    emit(state.copyWith(user: user));
  }

  void updateDataInicial(DateTime dataInicial) {
    final user = state.user.copyWith(startJob: dataInicial);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateDataLimite(DateTime dataLimite) {
    final user = state.user.copyWith(endJob: dataLimite);
    checkCadastroHabilitado();
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateIsVisitante(bool isVisitante) {
    final user = state.user.copyWith(isVisitor: isVisitante);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateIsAdmin(bool isAdmin) {
    final user = state.user.copyWith(isAdmin: isAdmin);
    emit(state.copyWith(user: user));
  }

  void updateEventos(List<String> eventos) {
    final user = state.user.copyWith(events: eventos);
    emit(state.copyWith(user: user));
  }

  void updateUpdatedAt(DateTime updatedAt) {
    final user = state.user.copyWith(updatedAt: updatedAt);
    emit(state.copyWith(user: user));
  }

  void updateIsBlocked(bool isBlocked) {
    final user = state.user.copyWith(isBlocked: isBlocked);
    emit(state.copyWith(user: user));
  }

  void updateArea(String area) {
    final user = state.user.copyWith(area: area);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void createEvent() async {
    emit(state.copyWith(isLoading: true));
    try {
      await eventRepository.createEvent(state.evento);
      createUser();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void createUser() async {
    emit(state.copyWith(isLoading: true));
    try {
      await userRepository.updateUser(state.user.id, state.user);
      clearFields();
      emit(state.copyWith(isLoading: false, userCreated: true));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void checkCadastroHabilitado() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    bool commonChecksPassed = state.user.name.isNotEmpty &&
        state.user.role.isNotEmpty &&
        state.user.bloodType.isNotEmpty &&
        state.user.company.isNotEmpty &&
        state.user.endJob.isAfter(state.user.startJob) &&
        state.user.endJob.isAfter(today);

    bool nonVisitorChecksPassed = state.user.isVisitor ||
        (!state.user.isVisitor &&
            state.user.aso.isBefore(today) &&
            state.user.nr34.isBefore(today));

    if (commonChecksPassed && nonVisitorChecksPassed) {
      emit(state.copyWith(cadastroHabilitado: true));
    } else {
      emit(state.copyWith(cadastroHabilitado: false));
    }
  }

  void clearFields() {
    final user = state.user.copyWith(
      id: '', // Provide an initial value or keep it empty if appropriate
      authorizationsId: [], // An empty list as an initial value
      name: '',
      company: '',
      role: '',
      project: '',
      number: 0,
      bloodType: '',
      cpf: '',
      aso: DateTime.now(), // Current timestamp or a placeholder date
      asoDocument: '',
      hasAso: false,
      nr34: DateTime.now(), // Similar to aso
      nr34Document: '',
      hasNr34: false,
      nr35: DateTime.now(), // Similar to aso
      nr35Document: '',
      hasNr35: false,
      nr33: DateTime.now(), // Similar to aso
      nr33Document: '',
      hasNr33: false,
      nr10: DateTime.now(), // Similar to aso
      nr10Document: '',
      hasNr10: false,
      email: '',
      area: '', // Provide a default area or keep it empty
      isAdmin: false,
      isVisitor: false,
      isPortalo: false,
      isOnboarded: false,
      isBlocked: false,
      blockReason: '',
      iTag: '',
      picture: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      events: [],
      typeJob: '',
      startJob: DateTime.now(),
      endJob: DateTime.now(),
      username: '',
      salt: '',
      hash: '',
      status: '',
    );
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
}
