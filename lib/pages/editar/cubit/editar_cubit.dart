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
              name: '',
              role: '',
              number: 0,
              bloodType: '',
              cpf: '',
              email: '',
              username: '',
              salt: '',
              hash: '',
              status: '',
              companyId: '',
              isBlocked: false,
              blockReason: '',
              canCreate: false,
            ),
            evento: Event(
              id: Uuid().v4(),
              timestamp: DateTime.now(),
              beaconId: '',
              action: 0,
              status: '',
              employeeId: '',
              sensorId: '',
              projectId: '',
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

  void updateIsBlocked(bool isBlocked) {
    final user = state.user.copyWith(isBlocked: isBlocked);
    emit(state.copyWith(user: user));
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
        state.user.bloodType.isNotEmpty;

    if (commonChecksPassed) {
      emit(state.copyWith(cadastroHabilitado: true));
    } else {
      emit(state.copyWith(cadastroHabilitado: false));
    }
  }

  void clearFields() {
    final user = state.user.copyWith(
      id: '', // Provide an initial value or keep it empty if appropriate

      name: '',

      role: '',

      number: 0,
      bloodType: '',
      cpf: '',

      email: '',

      isBlocked: false,
      blockReason: '',

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
        timestamp: DateTime.now(),
        action: 0,
        status: '',
        beaconId: '',
        projectId: '',
        employeeId: '',
        sensorId: '',
      ),
      userCreated: false,
      cadastroHabilitado: false,
    ));
  }
}
