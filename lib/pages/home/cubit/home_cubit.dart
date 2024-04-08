/*import 'dart:async';

import 'package:dockcheck/models/authorization.dart';
import 'package:dockcheck/models/vessel.dart';
import 'package:dockcheck/repositories/user_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/simple_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user.dart';
import '../../../repositories/authorization_repository.dart';
import '../../../repositories/vessel_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository userRepository;
  final VesselRepository vesselRepository;
  final LocalStorageService localStorageService;
  final AuthorizationRepository authorizationRepository;

  HomeCubit(
    this.userRepository,
    this.localStorageService,
    this.vesselRepository,
    this.authorizationRepository,
  ) : super(HomeState());

  //local logged user, vessels and onboard users
  User? _loggedUser;
  List<Vessel>? _vessels;
  List<User>? _onboardUsers;
  List<User>? _blocked;
  @override
  bool isClosed = false;

  //fetch last added user
  void fetchLoggedUser() async {
    if (!isClosed && state.isLoading == false) {
      emit(HomeState(isLoading: true));
    }
    try {
      String? userNumber = await localStorageService.getUserId();
      User user = await userRepository.getUser(userNumber ?? "");
      _loggedUser = user;
      fetchVessels();
    } catch (e) {
      if (e is Exception && e.toString() == "Exception: InvalidTokenError") {
        // Handle the specific 'jwt expired' error
        if (!isClosed) {
          emit(HomeState(
              isLoading: false,
              error: 'Session expired. Please login again.',
              invalidToken: true));
        }
      } else {
        // Handle other errors
        if (!isClosed) {
          emit(HomeState(isLoading: false, error: 'An error occurred.'));
        }
      }
    }
  }

  //fetch list of vessels from logged user based on user.authorization and the authorization.vesselId from vessel repository and set it to state, if any
  void fetchVessels() async {
    try {
      if (!isClosed) {
        emit(HomeState(isLoading: true));
      }
      //retrieve user_id from local storage
      String? userNumber = await localStorageService.getUserId();
      //fetch logged user
      User user = await userRepository.getUser(userNumber ?? "");
      //fetch authorizations from logged user
      List<Authorization> authorizations =
          await authorizationRepository.getAuthorizations(user.id);
      SimpleLogger.info('authorizations: $authorizations');
      SimpleLogger.info('authorizations: ${user.id}');
      //fetch each vessel from authorizations with getVesselById from vessel repository and set it to vessels list
      List<Vessel> vessels = [];
      for (var authorization in authorizations) {
        //TODO: alterar
        /*Vessel vessel = await vesselRepository.getVessel(authorization.vesselId);
        vessels.add(vessel);
        localStorageService.saveVesselId(vessel.id);*/
      }
      SimpleLogger.info('vessels cubit: $vessels');

      List<User> allUsers = await userRepository.getAllUsers();
      SimpleLogger.info('allUsers: $allUsers');
      //fetch the ids of the users from vessel repository
      List<User> blockedUsers = [];
      for (var user in allUsers) {
        if (user.isBlocked) {
          blockedUsers.add(user);
        }
      }
      _blocked = blockedUsers;
      //for each vessel, fetch the onboard users
      for (var vessel in vessels) {
        fetchOnboardUsers(vessel.id);
      }

      _vessels = vessels;
    } catch (e) {
      if (!isClosed) {
        emit(HomeState(resultMessage: e.toString(), isLoading: false));
      }
    }
  }

  //fetch onboard users from a vessel and set it to state onboardUsers list, fetch the ids of the users from vessel repository and then fetch the users from user repository
  void fetchOnboardUsers(String vesselId) async {
    //TODO: alterar para buscar usuários abordo (onboard)
    try {
      if (!isClosed && state.isLoading == false) {
        emit(HomeState(isLoading: true));
      }
      //fetch onboard users from vessel repository
      List<String> onboardUsers = await vesselRepository(vesselId);
      SimpleLogger.info('onboardUsers: $onboardUsers');
      //fetch the ids of the users from vessel repository
      List<String> onboardUsersIds = [];
      for (var onboardUser in onboardUsers) {
        onboardUsersIds.add(onboardUser);
      }
      SimpleLogger.info('onboardUsersIds: $onboardUsersIds');
      //fetch the users from user repository
      List<User> onboardUsersList = [];
      for (var onboardUserId in onboardUsersIds) {
        User onboardUser = await userRepository.getUser(onboardUserId);
        onboardUsersList.add(onboardUser);
      }
      SimpleLogger.info('onboardUsersList: $onboardUsersList');
      //set onboard users list to state
      _onboardUsers = onboardUsersList;

      if (_loggedUser != null && _vessels != null && _onboardUsers != null) {
        setLoggedUserAndVessels();
      }
    } catch (e) {
      if (!isClosed) {
        emit(HomeState(resultMessage: e.toString(), isLoading: false));
      }
    }
  }

  void setLoggedUserAndVessels() {
    if (!isClosed) {
      emit(HomeState(
        loggedUser: _loggedUser,
        vessels: _vessels!,
        onboardUsers: _onboardUsers!,
        isLoading: false,
        blockedUsers: _blocked!,
      ));
      // fetchBlockedUsers();
    }
  }

  void reloadPageFutureTimer(BuildContext context) {
    Timer.periodic(Duration(seconds: 20), (Timer timer) {
      context.read<HomeCubit>().reloadPage();
    });
  }

  //função para recarregar a página
  void reloadPage() {
    if (!isClosed) {}
    emit(HomeState(isLoading: true));
    fetchLoggedUser();
  }

  @override
  Future<void> close() async {
    if (!isClosed) {
      isClosed = true;

      // Dispose of any resources, cancel subscriptions, etc.
      // For example, if you have streams, make sure to close them.

      // Let the superclass handle the rest of the closing process.
      await super.close();
    }
  }
}

//when _loggedUser, _vessels and _onboardUsers are set, set it to state
 


*/