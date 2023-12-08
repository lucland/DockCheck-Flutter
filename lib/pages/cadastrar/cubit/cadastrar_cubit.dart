// ignore_for_file: non_constant_identifier_names

import 'package:cripto_qr_googlemarine/repositories/event_repository.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';
import 'package:cripto_qr_googlemarine/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/event.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import 'cadastrar_state.dart';

class CadastrarCubit extends Cubit<CadastrarState> {
  final UserRepository userRepository;
  final EventRepository eventRepository;
  final LocalStorageService localStorageService;

  @override
  bool isClosed = false;

  CadastrarCubit(
      this.userRepository, this.eventRepository, this.localStorageService)
      : super(
          CadastrarState(
            numero: 0,
            user: User(
              id: '',
              authorizationsId: [""],
              name: '',
              company: '',
              role: '',
              project: '',
              number: 0,
              identidade: '',
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
              area: '',
              isAdmin: false,
              isVisitor: false,
              isGuardian: false,
              isOnboarded: false,
              isBlocked: false,
              blockReason: '',
              rfid: '',
              picture: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              events: [""],
              typeJob: '',
              startJob: DateTime.now(),
              endJob: DateTime.now(),
              username: '',
              salt: '',
              hash: '',
            ),
            evento: Event(
              id: '',
              portalId: '',
              userId: '',
              timestamp: DateTime.now(),
              direction: 0,
              picture: '',
              vesselId: '',
              action: 0,
              manual: false,
              justification: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ),
        );

  void fetchNumero() async {
    if (!isClosed) {
      try {
        var numero = await userRepository.getLastUserNumber();
        final user = state.user.copyWith(number: numero);
        emit(state.copyWith(user: user, isLoading: false, numero: numero));
      } catch (e) {
        SimpleLogger.warning('Error during data synchronization: $e');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void updateIdentidade(String userId) {
    String UUID = DateTime.now().millisecondsSinceEpoch.toString();
    final user = state.user.copyWith(identidade: userId, id: UUID);
    final evento = state.evento.copyWith(userId: userId, id: UUID);
    emit(state.copyWith(user: user, evento: evento));
    checkCadastroHabilitado();
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

  void updatePassword(String password) {
    final user = state.user.copyWith(salt: password, hash: '');
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

  void updateCreatedAt(DateTime createdAt) {
    final user = state.user.copyWith(createdAt: createdAt);
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
    //event vessel_id is the same as local storage vessel_id
    String vesselId = await localStorageService.getVesselId() ?? '';

    emit(state.copyWith(
        isLoading: true,
        evento: state.evento.copyWith(
          timestamp: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          action: 3,
          vesselId: vesselId,
          portalId: '0',
          direction: 0,
        )));
    try {
      await eventRepository.createEvent(state.evento);
      clearFields();
      emit(state.copyWith(isLoading: false, userCreated: true));
    } catch (e) {
      SimpleLogger.warning('Error during cadastrar_cubit createEvent: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void createUser() async {
    emit(state.copyWith(isLoading: true));
    try {
      await userRepository.createUser(state.user);
      createEvent();
    } catch (e) {
      SimpleLogger.warning('Error cadastrar_cubit createUser: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void checkCadastroHabilitado() {
    if (state.user.isVisitor) {
      if (commonChecksPassed()) {
        emit(state.copyWith(cadastroHabilitado: true));
      } else {
        emit(state.copyWith(cadastroHabilitado: false));
      }
    } else if (!state.user.isAdmin) {
      if (commonChecksPassed() && datesCheckPassed()) {
        emit(state.copyWith(cadastroHabilitado: true));
      } else {
        emit(state.copyWith(cadastroHabilitado: false));
      }
    } else {
      if (adminCheckPassed()) {
        emit(state.copyWith(cadastroHabilitado: true));
      } else {
        emit(state.copyWith(cadastroHabilitado: false));
      }
    }
  }

  bool commonChecksPassed() {
    return state.user.name.isNotEmpty &&
        state.user.role.isNotEmpty &&
        state.user.identidade.isNotEmpty &&
        state.user.company.isNotEmpty &&
        state.user.endJob.isAfter(state.user.startJob);
  }

  bool datesCheckPassed() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return state.user.aso.isAfter(today) && state.user.nr34.isAfter(today);
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
      identidade: '-',
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
      email: '-',
      area: '-',
      isAdmin: false,
      isVisitor: false,
      isGuardian: false,
      isOnboarded: false,
      isBlocked: false,
      blockReason: '-',
      rfid: '-',
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
    );
    emit(state.copyWith(
      user: user,
      isLoading: false,
      evento: Event(
        id: '',
        portalId: '',
        userId: '',
        timestamp: DateTime.now(),
        direction: 0,
        picture: '',
        vesselId: '',
        action: 0,
        manual: false,
        justification: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      userCreated: false,
      cadastroHabilitado: false,
    ));
  }

  @override
  Future<void> close() {
    isClosed = true;
    return super.close();
  }
}
