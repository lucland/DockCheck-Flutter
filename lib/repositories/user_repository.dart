import 'dart:convert';
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/models/picture.dart';
import 'package:dockcheck/models/authorization.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import '../utils/simple_logger.dart';

class UserRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  UserRepository(this.apiService, this.localStorageService);

  Future<User> createUser(User user) async {
    try {
      final data = await apiService.post('users/create', user.toJson());
      SimpleLogger.info(user.toJson());
      return User.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create user: ${e.toString()}');
      user.status = 'pending_creation';
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

  Future<bool> getValidITag(String itag) async {
    try {
      await apiService.get('users/itag/$itag');
      return true;
    } catch (e) {
      SimpleLogger.severe('iTag not valid: ${e.toString()}');
      return false;
    }
  }

  Future<User> updateUser(String id, User user) async {
    final data = await apiService.put('users/$id', user.toJson());
    return User.fromJson(data);
  }

  Future<void> deleteUser(String id) async {
    await apiService.delete('users/$id');
  }

  Future<List<User>> getAllUsers({int limit = 10000, int offset = 0}) async {
    final data1 = await apiService.get('users');//users
    List<User> users =
        (data1 as List).map((item) => User.fromJson(item)).toList();
        print("Data fetched: $data1");
    return users;
  }

    Future<List<Employee>> getAllEmployees() async {
    final data = await apiService.get('employees');
    if (data != null && data is List) {
      print("Data fetched: $data");
      var list = (data as List).map((item) => Employee.fromJson(item)).toList();
      print("First employee name: ${list.first.name}"); // More detailed log
      return list;
    } else {
      print("Data fetched is null");
      return [];
    }
  }


  Future<List<Authorization>> getUserAuthorizations(String userId) async {
    final data = await apiService.get('users/$userId/authorizations');
    return (data as List).map((item) => Authorization.fromJson(item)).toList();
  }

  Future<bool> checkUsername(String username) async {
    final data =
        await apiService.post('users/checkUsername', {'username': username});
    return data['message'] == 'Username available';
  }

  Future<List<User>> searchUsers(String searchTerm,
      {int page = 1, int pageSize = 10}) async {
    const String apiUrl = 'http://172.20.255.223:3000/api/v1/users/search';
    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: {
      'searchTerm': searchTerm,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['users'] as List)
            .map((item) => User.fromJson(item))
            .toList();
      } else {
        print('Failed to load users');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<int> getLastUserNumber() async {
    final data = await apiService.get('users/all/lastnumber');
    return int.parse(data.toString());
  }

  Future<List<String>> getValidUsersByVesselID(String vesselId) async {
    final data = await apiService.get('users/valids/$vesselId');
    return List<String>.from(data);
  }

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
          SimpleLogger.info('User synchronized');
        }
      } catch (e) {
        SimpleLogger.severe('Failed to sync pending user: ${e.toString()}');
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
      } catch (e) {
        SimpleLogger.warning('Failed to fetch user: $id, error: $e');
      }
    }
  }

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

  Future<void> createEmployeePicture(
      String id, String employeeId, String base64, String docPath) async {
    try {
      final response = await apiService.post(
        'createEmployeePicture',
        {
          'id': id,
          'employee_id': employeeId,
          'base_64': base64,
          'doc_path': docPath,
        },
      );

      if (response.containsKey('error')) {
        SimpleLogger.warning("Error creating employee picture");
        throw Exception(response['error']);
      } else {
        SimpleLogger.info("Employee picture created successfully");
      }
    } catch (error) {
      SimpleLogger.severe(
          "Error creating employee picture: ${error.toString()}");
      throw Exception('Error creating employee picture');
    }
  }

  Future<Picture> getPicture(String id) async {
    try {
      final data = await apiService.get('getPicture/$id');
      return Picture.fromJson(data);
    } catch (error) {
      SimpleLogger.severe("Error getting picture: ${error.toString()}");
      throw Exception('Error getting picture');
    }
  }

  Future<void> updatePicture(String id, String picture) async {
    try {
      final response =
          await apiService.put('updatePicture/$id', {'picture': picture});
      if (response.containsKey('error')) {
        SimpleLogger.warning("Error updating picture");
        throw Exception(response['error']);
      } else {
        SimpleLogger.info("Picture updated successfully");
      }
    } catch (error) {
      SimpleLogger.severe("Error updating picture: ${error.toString()}");
      throw Exception('Error updating picture');
    }
  }

  Future<void> deletePicture(String id) async {
    try {
      final response = await apiService.delete('deletePicture/$id');
      if (response.containsKey('error')) {
        SimpleLogger.warning("Error deleting picture");
        throw Exception(response['error']);
      } else {
        SimpleLogger.info("Picture deleted successfully");
      }
    } catch (error) {
      SimpleLogger.severe("Error deleting picture: ${error.toString()}");
      throw Exception('Error deleting picture');
    }
  }
}
