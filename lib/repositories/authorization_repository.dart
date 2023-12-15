import '../models/authorization.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class AuthorizationRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  AuthorizationRepository(this.apiService, this.localStorageService);

  Future<Authorization> createAuthorization(Authorization authorization) async {
    await localStorageService.insertOrUpdate(
        'authorizations', authorization.toJson(), 'id');

    try {
      final data =
          await apiService.post('authorizations', authorization.toJson());
      await localStorageService.insertOrUpdate(
          'authorizations', Authorization.fromJson(data).toJson(), 'id');
      return Authorization.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create authorization: ${e.toString()}');
      return authorization;
    }
  }

  Future<Authorization> getAuthorizationById(String id) async {
    try {
      final data = await apiService.get('authorizations/$id');
      return Authorization.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get authorization: ${e.toString()}');
      final localData =
          await localStorageService.getDataById('authorizations', id);
      return Authorization.fromJson(localData);
    }
  }

  Future<List<Authorization>> getAuthorizations(String userId) async {
    try {
      final data = await apiService.get('authorizations/$userId');
      return (data as List)
          .map((item) => Authorization.fromJson(item))
          .toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get authorizations: ${e.toString()}');
      // Fetch from local storage as fallback
      // Implement logic to return data from local storage or an empty list
      return []; // Return an empty list as a fallback
    }
  }

  Future<Authorization> updateAuthorization(
      String id, Authorization authorization) async {
    try {
      final data =
          await apiService.put('authorizations/$id', authorization.toJson());
      await localStorageService.insertOrUpdate(
          'authorizations', Authorization.fromJson(data).toJson(), 'id');
      return Authorization.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update authorization: ${e.toString()}');
      authorization.status = 'pending_update'; // Assuming 'status' field exists
      await localStorageService.insertOrUpdate(
          'authorizations', authorization.toJson(), 'id');
      return authorization;
    }
  }

  Future<void> deleteAuthorization(String id) async {
    await apiService.delete('authorizations/$id');
  }

  Future<List<Authorization>> getAuthorizationsFromServer() async {
    final data = await apiService.get('authorizations');
    return (data as List).map((item) => Authorization.fromJson(item)).toList();
  }

  //getAuthorizationIdsFromServer returns a list of authorization ids
  Future<List<String>> getAuthorizationIdsFromServer() async {
    final data = await apiService.get('authorizations/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<void> fetchAndStoreNewAuthorizations(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('authorizations/$id');
      final auth = Authorization.fromJson(authData);
      await localStorageService.insertData('authorizations', auth.toJson());
    }
  }

  Future<void> syncAuthorizations() async {
    SimpleLogger.info('Syncing authorizations');

    // First, try to fetch new data from the server
    try {
      var serverAuthorizations = await getAuthorizationsFromServer();
      await updateLocalDatabase(
          serverAuthorizations); // Update local database with new data
    } catch (e) {
      SimpleLogger.warning('Error fetching authorizations from server: $e');
      // If fetching from server fails, use local data
    }

    // Then, sync any pending updates from local storage to the server
    var pendingAuthorizations =
        await localStorageService.getPendingData('authorizations', 'status');
    for (var pending in pendingAuthorizations) {
      try {
        var response = await apiService.post('authorizations', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate(
              'authorizations', pending, 'id');
          SimpleLogger.info('Authorization synchronized');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending authorization: $e');
        // If syncing fails, leave it as pending
      }
    }
  }

  // ... (other methods) ...

  // Add a method to update local storage with new data from the server
  Future<void> updateLocalDatabase(
      List<Authorization> serverAuthorizations) async {
    for (var auth in serverAuthorizations) {
      var localData =
          await localStorageService.getDataById('authorizations', auth.id);
      if (localData.isEmpty) {
        await localStorageService.insertData('authorizations', auth.toJson());
      } else {
        await localStorageService.updateData(
            'authorizations', auth.toJson(), 'id');
      }
    }
  }
}
