import '../models/authorization.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class AuthorizationRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  AuthorizationRepository(this.apiService, this.localStorageService);

  Future<Authorization> createAuthorization(Authorization authorization) async {
    final data =
        await apiService.post('authorizations', authorization.toJson());
    return Authorization.fromJson(data);
  }

  Future<List<Authorization>> getAuthorizations(String userId) async {
    final data = await apiService.get('authorizations/$userId');
    var authorizations =
        (data as List).map((item) => Authorization.fromJson(item)).toList();

    // Store the data locally
    for (var auth in authorizations) {
      await localStorageService.insertData('authorizations', auth.toJson());
    }

    return authorizations;
  }

  Future<Authorization> getAuthorizationById(String id) async {
    final data = await apiService.get('authorizations/$id');
    return Authorization.fromJson(data);
  }

  Future<Authorization> updateAuthorization(
      String id, Authorization authorization) async {
    final data =
        await apiService.put('authorizations/$id', authorization.toJson());
    return Authorization.fromJson(data);
  }

  Future<void> deleteAuthorization(String id) async {
    await apiService.delete('authorizations/$id');
  }

  Future<void> syncAuthorizations() async {
    try {
      final serverAuthorizations = await getAuthorizationsFromServer();

      await updateLocalDatabase(serverAuthorizations);
    } catch (e) {
      // Handle errors
    }
  }

  Future<List<Authorization>> getAuthorizationsFromServer() async {
    final data = await apiService.get('authorizations');
    return (data as List).map((item) => Authorization.fromJson(item)).toList();
  }

  Future<void> updateLocalDatabase(
      List<Authorization> serverAuthorizations) async {
    // Clear local data or implement a more sophisticated update logic
    await localStorageService.clearTable('authorizations');

    // Insert fetched data into the local database
    for (var auth in serverAuthorizations) {
      await localStorageService.insertData('authorizations', auth.toJson());
    }
  }
}
