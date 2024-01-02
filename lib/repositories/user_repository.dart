import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';

import '../models/authorization.dart';
import '../utils/simple_logger.dart';

class UserRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  UserRepository(this.apiService, this.localStorageService);

  Future<User> createUser(User user) async {
    try {
      final data = await apiService.post('users/create', user.toJson());
      await localStorageService.insertOrUpdate(
          'users', User.fromJson(data).toJson(), 'id');
      return User.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create user: ${e.toString()}');
      user.status = 'pending_creation';
      await localStorageService.insertOrUpdate('users', user.toJson(), 'id');
      return user;
    }
  }

  Future<User> getUser(String id) async {
    try {
      final data = await apiService.get('users/$id');
      return User.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get user: ${e.toString()}');
      final localData = await localStorageService.getDataById('users', id);
      if (localData.isNotEmpty) {
        return User.fromJson(localData);
      } else {
        throw Exception('User not found locally');
      }
    }
  }

  Future<User> updateUser(String id, User user) async {
    final data = await apiService.put('users/$id', user.toJson());
    return User.fromJson(data);
  }

  Future<void> deleteUser(String id) async {
    await apiService.delete('users/$id');
  }

  Future<List<User>> getAllUsers({int limit = 10, int offset = 0}) async {
    final data = await apiService.get('users?limit=$limit&offset=$offset');
    return (data as List).map((item) => User.fromJson(item)).toList();
  }

  // Get User Authorizations
  Future<List<Authorization>> getUserAuthorizations(String userId) async {
    final data = await apiService.get('users/$userId/authorizations');
    return (data as List).map((item) => Authorization.fromJson(item)).toList();
  }

  // Check Username Availability
  Future<bool> checkUsername(String username) async {
    final data =
        await apiService.post('users/checkUsername', {'username': username});
    return data['message'] == 'Username available';
  }

  // Search Users
  Future<List<User>> searchUsers(
      String searchTerm, int page, int pageSize) async {
    final data = await apiService.get(
        'users/search?searchTerm=$searchTerm&page=$page&pageSize=$pageSize');
    return (data['users'] as List).map((item) => User.fromJson(item)).toList();
  }

  // Get Last User Number
  Future<int> getLastUserNumber() async {
    final data = await apiService.get('users/all/lastnumber');
    return int.parse(data.toString());
  }

  // Get Valid Users by Vessel ID
  Future<List<String>> getValidUsersByVesselID(String vesselId) async {
    final data = await apiService.get('users/valids/$vesselId');
    return List<String>.from(data);
  }

  //sync pending users
  Future<void> syncPendingUsers() async {
    SimpleLogger.info('Syncing users');
    var pendingUsers =
        await localStorageService.getPendingData('users', 'status');

    for (var pending in pendingUsers) {
      try {
        var response;
        if (pending['status'] == 'pending_creation') {
          response = await apiService.post('users/create', pending);
        } else if (pending['status'] == 'pending_update') {
          response = await apiService.put('users/${pending['id']}', pending);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate('users', pending, 'id');
          SimpleLogger.info('User synchronized');
        }
      } catch (e) {
        SimpleLogger.severe('Failed to sync pending user: ${e.toString()}');
        // If syncing fails, leave it as pending
      }
    }
  }

  Future<void> updateLocalDatabase(List<User> serverUsers) async {
    for (var user in serverUsers) {
      var localData = await localStorageService.getDataById('users', user.id);
      if (localData.isEmpty) {
        await localStorageService.insertData('users', user.toJson());
      } else {
        await localStorageService.updateData('users', user.toJson(), 'id');
      }
    }
  }

  Future<void> fetchAndStoreNewUsers(List<String> newIds) async {
    for (String id in newIds) {
      try {
        final userData = await apiService.get('users/$id');
        final user = User.fromJson(userData);
        await localStorageService.insertOrUpdate('users', user.toJson(), 'id');
      } catch (e) {
        SimpleLogger.warning('Failed to fetch user: $id, error: $e');
        // Continue with the next ID if one fetch fails
      }
    }
  }

  //getUsersIdsFromServer returns a list of user ids
  Future<List<String>> getUsersIdsFromServer() async {
    final data = await apiService.get('users/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<User> getUserByBeacon(String id) async {
    try {
      final data = await apiService.get('users/user/rfid/$id');
      return User.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get user: ${e.toString()}');
      final localData = await localStorageService.getDataById('users', id);
      if (localData.isNotEmpty) {
        return User.fromJson(localData);
      } else {
        throw Exception('User not found locally');
      }
    }
  }
}
