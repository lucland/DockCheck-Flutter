import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_qr_googlemarine/models/evento.dart';
import 'package:cripto_qr_googlemarine/utils/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import 'editar_state.dart';

class EditarCubit extends Cubit<EditarState> {
  final UserRepository userRepository;
  final User originalUser;

  EditarCubit(this.userRepository, this.originalUser)
      : super(
          EditarState(
            numero: 0,
            user: User(
              numero: 0,
              identidade: '',
              nome: '',
              funcao: '',
              email: '',
              empresa: '',
              ASO: Timestamp.now(),
              NR34: Timestamp.now(),
              NR10: Timestamp.now(),
              NR33: Timestamp.now(),
              NR35: Timestamp.now(),
              vessel: 'SKANDI AMAZONAS',
              dataInicial: Timestamp.now(),
              dataLimite: Timestamp.now(),
              isVisitante: false,
              isAdmin: false,
              eventos: [],
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
              isBlocked: false,
              area: AreasEnum.pracaDeMaquinas,
              reason: '',
              isOnboarded: false,
              isSupervisor: false,
              password: '',
            ),
            evento: Evento(
              acao: CQStrings.usuarioEditado,
              user: '',
              vessel: 'SKANDI AMAZONAS',
              createdAt: Timestamp.now(),
            ),
          ),
        );

  void originalUserData(User userr) async {
    await Future.delayed(Duration(milliseconds: 500));
    emit(state.copyWith(user: userr, isLoading: false, numero: userr.numero));
  }

  void updateIdentidade(String identidade) {
    final user = state.user.copyWith(identidade: identidade);
    final evento = state.evento.copyWith(user: identidade);
    checkCadastroHabilitado();
    emit(state.copyWith(user: user, evento: evento));
  }

  void updateNome(String nome) {
    final user = state.user.copyWith(nome: nome);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateFuncao(String funcao) {
    final user = state.user.copyWith(funcao: funcao);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateEmail(String email) {
    final user = state.user.copyWith(email: email);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateEmpresa(String empresa) {
    final user = state.user.copyWith(empresa: empresa);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateASO(Timestamp ASO) {
    final user = state.user.copyWith(ASO: ASO);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateNR34(Timestamp NR34) {
    final user = state.user.copyWith(NR34: NR34);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateNR10(Timestamp NR10) {
    final user = state.user.copyWith(NR10: NR10);
    emit(state.copyWith(user: user));
  }

  void updatePassword(String password) {
    final user = state.user.copyWith(password: password);
    emit(state.copyWith(user: user));
  }

  void updateNR33(Timestamp NR33) {
    final user = state.user.copyWith(NR33: NR33);
    emit(state.copyWith(user: user));
  }

  void updateNR35(Timestamp NR35) {
    final user = state.user.copyWith(NR35: NR35);
    emit(state.copyWith(user: user));
  }

  void updateDataInicial(Timestamp dataInicial) {
    final user = state.user.copyWith(dataInicial: dataInicial);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateDataLimite(Timestamp dataLimite) {
    final user = state.user.copyWith(dataLimite: dataLimite);
    checkCadastroHabilitado();
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateIsVisitante(bool isVisitante) {
    final user = state.user.copyWith(isVisitante: isVisitante);
    emit(state.copyWith(user: user));
    checkCadastroHabilitado();
  }

  void updateIsAdmin(bool isAdmin) {
    final user = state.user.copyWith(isAdmin: isAdmin);
    emit(state.copyWith(user: user));
  }

  void updateVessel(String vessel) {
    final evento = state.evento.copyWith(vessel: vessel);
    final user = state.user.copyWith(vessel: vessel);
    emit(state.copyWith(evento: evento, user: user));
  }

  void updateEventos(List<String> eventos) {
    final user = state.user.copyWith(eventos: eventos);
    emit(state.copyWith(user: user));
  }

  void updateUpdatedAt(Timestamp updatedAt) {
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
      await userRepository.addEvent(state.evento.toMap());
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
      await userRepository.updateUser(state.user);
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
    Timestamp todayTimestamp =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    bool commonChecksPassed = state.user.nome.isNotEmpty &&
        state.user.funcao.isNotEmpty &&
        state.user.identidade.isNotEmpty &&
        state.user.empresa.isNotEmpty &&
        (state.user.dataLimite.seconds - todayTimestamp.seconds >= -80000);

    bool adminCheckPassed = !state.user.isAdmin ||
        (state.user.isAdmin && state.user.password.isNotEmpty);

    bool nonVisitorChecksPassed = state.user.isVisitante ||
        (!state.user.isVisitante &&
            state.user.ASO.seconds - todayTimestamp.seconds >= 86400 &&
            state.user.NR34.seconds - todayTimestamp.seconds >= 86400);

    if (commonChecksPassed && adminCheckPassed && nonVisitorChecksPassed) {
      emit(state.copyWith(cadastroHabilitado: true));
    } else {
      emit(state.copyWith(cadastroHabilitado: false));
    }
  }

  void clearFields() {
    final user = state.user.copyWith(
      numero: state.numero,
      identidade: '',
      nome: '',
      funcao: '',
      email: '',
      empresa: '',
      ASO: Timestamp.now(),
      NR34: Timestamp.now(),
      NR10: Timestamp.now(),
      NR33: Timestamp.now(),
      NR35: Timestamp.now(),
      vessel: 'SKANDI AMAZONAS',
      dataInicial: Timestamp.now(),
      dataLimite: Timestamp.now(),
      isVisitante: false,
      isAdmin: false,
      eventos: [],
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      isBlocked: false,
      area: AreasEnum.pracaDeMaquinas,
      reason: "",
      isOnboarded: false,
      isSupervisor: false,
      password: "",
    );
    emit(state.copyWith(
      user: user,
      isLoading: false,
      evento: Evento(
        acao: CQStrings.usuarioEditado,
        user: '',
        vessel: '',
        createdAt: Timestamp.now(),
      ),
      userCreated: false,
      cadastroHabilitado: false,
    ));
  }
}
