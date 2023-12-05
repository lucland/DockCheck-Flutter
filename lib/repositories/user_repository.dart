import 'package:cripto_qr_googlemarine/models/user.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

import '../models/authorization.dart';
import '../utils/simple_logger.dart';

class UserRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  UserRepository(this.apiService, this.localStorageService);

  Future<User> createUser(User user) async {
    final data = await apiService.post('users/create', user.toJson());
    return User.fromJson(data);
  }

  Future<User> getUser(String id) async {
    final data = await apiService.get('users/$id');
    return User.fromJson(data);
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

  Future<void> syncUsers() async {
    try {
      final localIds = await localStorageService.getIds('users');
      final serverIds = await getUsersIdsFromServer();

      final newIds = serverIds.where((id) => !localIds.contains(id)).toList();

      if (newIds.isNotEmpty) {
        await fetchAndStoreNewUsers(newIds).then(
            (value) => SimpleLogger.fine('User synchronization completed'),
            onError: (e) => SimpleLogger.severe('User synchronization failed'));
      }
    } catch (e) {
      SimpleLogger.severe('User synchronization failed');
    }
  }

  Future<void> updateLocalDatabase(List<User> serverUsers) async {
    // Clear local data
    await localStorageService.clearTable('users');

    // Insert new data into the local database
    for (var user in serverUsers) {
      await localStorageService.insertData('users', user.toJson());
    }
  }

  //getUsersIdsFromServer returns a list of user ids
  Future<List<String>> getUsersIdsFromServer() async {
    final data = await apiService.get('users/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  //fetch and store new users
  Future<void> fetchAndStoreNewUsers(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('users/$id');
      final auth = User.fromJson(authData);
      await localStorageService.insertData('users', auth.toJson());
    }
  }
}
