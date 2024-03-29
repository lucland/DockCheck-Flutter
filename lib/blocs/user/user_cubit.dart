import 'dart:async';

import 'package:dockcheck/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  bool isSearching = false;
  String searchQuery = '';

  @override
  bool isClosed = false;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> fetchUsers() async {
    try {
      if (!isClosed) {
        emit(UserLoading());
      }

      allUsers = await userRepository.getAllUsers();

      if (!isClosed) {
        if (isSearching) {
          _applySearchFilter();
        } else {
          emit(UserLoaded(allUsers));
        }
      }
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      if (!isClosed) {
        emit(UserError("Failed to fetch users1. $e"));
      }
    }
  }

  Future<void> searchUsers(String query, {bool filterByNumber = false}) async {
    try {
      if (!isClosed) {
        emit(UserLoading());
      }

      searchQuery = query;
      isSearching = true;

      // Verifica se já carregou os usuários do banco de dados
      if (allUsers.isEmpty) {
        allUsers = await userRepository.getAllUsers();
      }

      filteredUsers = allUsers.where((user) {
        final nameMatches =
            user.name.toLowerCase().contains(query.toLowerCase());
        final numberMatches = filterByNumber &&
            user.number.toString().contains(query.toLowerCase());
        return nameMatches || numberMatches;
      }).toList();

      if (!isClosed) {
        emit(UserLoaded(filteredUsers));
      }
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      if (!isClosed) {
        emit(UserError("Failed to fetch users. $e"));
      }
    }
  }

  void _applySearchFilter({bool filterByNumber = false}) {
    filteredUsers = allUsers
        .where((user) =>
            user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (filterByNumber &&
                user.number.toString().contains(searchQuery.toLowerCase())))
        .toList();

    emit(UserLoaded(filteredUsers));
  }

  @override
  Future<void> close() async {
    if (!isClosed) {
      isClosed = true;
      await super.close();
    }
  }
}
