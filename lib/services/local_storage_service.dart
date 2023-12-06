import 'dart:convert';

import 'package:cripto_qr_googlemarine/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorageService {
  final _secureStorage = const FlutterSecureStorage();
  Database? _database;

  // Initialize the LocalStorageService
  Future<void> init() async {
    await initDB(); // Initialize the database
    // Add any other initialization logic if needed
  }

  // Secure Storage
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  //delete token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  //save vesselId
  Future<void> saveVesselId(String vesselId) async {
    await _secureStorage.write(key: 'vessel_id', value: vesselId);
  }

  //delete vesselId
  Future<void> deleteVesselId() async {
    await _secureStorage.delete(key: 'vessel_id');
  }

  Future<String?> getVesselId() async {
    return await _secureStorage.read(key: 'vessel_id');
  }

  //save userId
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'user_id');
  }

  //save username
  Future<void> saveUsername(String username) async {
    await _secureStorage.write(key: 'username', value: username);
  }

  //get username
  Future<String?> getUsername() async {
    return await _secureStorage.read(key: 'username');
  }

  //delete username
  Future<void> deleteUsername() async {
    await _secureStorage.delete(key: 'username');
  }

  Future<void> saveUser(User user) async {
    await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    try {
      final userString = await _secureStorage.read(key: 'user');
      if (userString != null &&
          userString.startsWith('{') &&
          userString.endsWith('}')) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        print('User JSON: $userMap');
        return User.fromJson(userMap);
      } else {
        print('Invalid or null user string: $userString');
        // Handle the case where userString is not a valid JSON
      }
    } catch (e) {
      print('Error decoding user JSON: $e');
      // Handle or log the error
    }
    return null;
  }

//delete user
  Future<void> deleteUser() async {
    await _secureStorage.delete(key: 'user');
  }

  //delete userId
  Future<void> deleteUserId() async {
    await _secureStorage.delete(key: 'user_id');
  }

  // SQLite
  Future<void> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables here
        await db.execute(
          'CREATE TABLE Test(id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)',
        );
      },
    );
  }

  Future<void> insertData(String table, Map<String, dynamic> data) async {
    await _database?.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    return await _database?.query(table) ?? [];
  }

  Future<void> clearTable(String table) async {
    await _database?.delete(table);
  }

  // ... (other methods)
  Future closeDB() async {
    await _database?.close();
  }

  Future<List<String>> getIds(String table) async {
    final List<Map<String, dynamic>> result =
        await _database?.query(table, columns: ['id']) ?? [];
    return result.map((item) => item['id'] as String).toList();
  }
}
