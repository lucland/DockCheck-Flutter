import 'package:cripto_qr_googlemarine/repositories/event_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/event.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import 'cadastrar_state.dart';

class CadastrarCubit extends Cubit<CadastrarState> {
  final UserRepository userRepository;
  final EventRepository eventRepository;

  bool isClosed = false;

  CadastrarCubit(this.userRepository, this.eventRepository)
      : super(
          CadastrarState(
            numero: 0,
            user: User(
              id: '', // Provide an initial value or keep it empty if appropriate
              authorizationsId: [], // An empty list as an initial value
              name: '',
              company: '',
              role: '',
              project: '',
              number: 0,
              identidade: '',
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
              isGuardian: false,
              isOnboarded: false,
              isBlocked: false,
              blockReason: '',
              rfid: '',
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
        numero++;
        final user = state.user.copyWith(number: numero);
        emit(state.copyWith(user: user, isLoading: false, numero: numero));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void updateIdentidade(String userId) {
    final user = state.user.copyWith(identidade: userId);
    final evento = state.evento.copyWith(userId: userId);
    checkCadastroHabilitado();
    emit(state.copyWith(user: user, evento: evento));
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
      await userRepository.createUser(state.user);
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
        state.user.identidade.isNotEmpty &&
        state.user.company.isNotEmpty &&
        state.user.endJob.isAfter(state.user.startJob) &&
        state.user.endJob.isAfter(today);

    bool nonVisitorChecksPassed = state.user.isVisitor ||
        (!state.user.isVisitor &&
            state.user.aso.isBefore(today) &&
            state.user.nr34.isBefore(today));

    bool adminCheckPassed = !state.user.isAdmin ||
        (state.user.isAdmin && state.user.hash.isNotEmpty);

    if (commonChecksPassed && adminCheckPassed && nonVisitorChecksPassed) {
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
      identidade: '',
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
      isGuardian: false,
      isOnboarded: false,
      isBlocked: false,
      blockReason: '',
      rfid: '',
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
