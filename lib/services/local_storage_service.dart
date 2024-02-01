import 'dart:convert';

import 'package:dockcheck/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../utils/simple_logger.dart';

class LocalStorageService {
  final _secureStorage = const FlutterSecureStorage();
  Database? _database;

  // Initialize the LocalStorageService
  Future<void> init() async {
    SimpleLogger.info("Initializing Local Storage Service");
    await initDB(); // Initialize the database
    // Add any other initialization logic if needed
  }

  Future<void> ensureTableExists(String tableName) async {
    await initDB(); // Ensure DB is initialized
    List<Map<String, Object?>>? list = await _database?.rawQuery(
        'SELECT name FROM sqlite_master WHERE type="table" AND name="$tableName"');
    if (list!.isEmpty) {
      String createTableSQL = createTableSQLForModel(tableName);
      if (createTableSQL.isNotEmpty) {
        await _database?.execute(createTableSQL);
      }
    }
  }

  // Secure Storage
  Future<void> saveToken(String token) async {
    SimpleLogger.info("Saving token: $token");
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  //delete token
  Future<void> deleteToken() async {
    SimpleLogger.info("Deleting token");
    await _secureStorage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async {
    SimpleLogger.info("Getting token");
    return await _secureStorage.read(key: 'jwt_token');
  }

  //save vesselId
  Future<void> saveVesselId(String vesselId) async {
    SimpleLogger.info("Saving vesselId: $vesselId");
    await _secureStorage.write(key: 'vessel_id', value: vesselId);
  }

  //delete vesselId
  Future<void> deleteVesselId() async {
    SimpleLogger.info("Deleting vesselId");
    await _secureStorage.delete(key: 'vessel_id');
  }

  Future<String?> getVesselId() async {
    SimpleLogger.info("Getting vesselId");
    return await _secureStorage.read(key: 'vessel_id');
  }

  //save userId
  Future<void> saveUserId(String userId) async {
    SimpleLogger.info("Saving userId: $userId");
    await _secureStorage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserId() async {
    SimpleLogger.info("Getting userId");
    return await _secureStorage.read(key: 'user_id');
  }

  //save username
  Future<void> saveUsername(String username) async {
    SimpleLogger.info("Saving username: $username");
    await _secureStorage.write(key: 'username', value: username);
  }

  //get username
  Future<String?> getUsername() async {
    SimpleLogger.info("Getting username");
    return await _secureStorage.read(key: 'username');
  }

  //delete username
  Future<void> deleteUsername() async {
    SimpleLogger.info("Deleting username");
    await _secureStorage.delete(key: 'username');
  }

  Future<void> saveUser(User user) async {
    SimpleLogger.info("Saving user: ${user.toJson()}");
    await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    SimpleLogger.info("Getting user");
    try {
      final userString = await _secureStorage.read(key: 'user');
      if (userString != null &&
          userString.startsWith('{') &&
          userString.endsWith('}')) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        print('User JSON: $userMap');
        SimpleLogger.info('User JSON: $userMap');
        return User.fromJson(userMap);
      } else {
        SimpleLogger.warning('Invalid or null user string: $userString');
        print('Invalid or null user string: $userString');
        // Handle the case where userString is not a valid JSON
      }
    } catch (e) {
      SimpleLogger.severe('Error decoding user JSON: $e');
      print('Error decoding user JSON: $e');
      // Handle or log the error
    }
    return null;
  }

//delete user
  Future<void> deleteUser() async {
    SimpleLogger.info("Deleting user");
    await _secureStorage.delete(key: 'user');
  }

  //delete userId
  Future<void> deleteUserId() async {
    SimpleLogger.info("Deleting userId");
    await _secureStorage.delete(key: 'user_id');
  }

  //For Syncing
  /*Future<void> insertOrUpdate(
      String table, Map<String, dynamic> data, String idColumn) async {
    SimpleLogger.info("Inserting or updating data: $data");
    var existingData = await _database
        ?.query(table, where: '$idColumn = ?', whereArgs: [data[idColumn]]);
    if (existingData != null && existingData.isNotEmpty) {
      SimpleLogger.info("Updating data: $data");
      await _database?.update(table, data,
          where: '$idColumn = ?', whereArgs: [data[idColumn]]);
    } else {
      SimpleLogger.info("Inserting data: $data");
      await _database?.insert(table, data);
    }
  }
*/
  Future<List<Map<String, dynamic>>> getPendingData(
      String table, String statusColumn) async {
    SimpleLogger.info("Getting pending data from table: $table");
    final data = await _database
        ?.query(table, where: '$statusColumn = ?', whereArgs: ['pending']);
    SimpleLogger.info("Pending data: $data");
    return data ?? [];
  }

  //method to get all data from table
  Future<List<Map<String, dynamic>>> getAllData(String table) async {
    SimpleLogger.info("Getting all data from table: $table");
    final data = await _database?.query(table);
    SimpleLogger.info("All data: $data");
    return data ?? [];
  }

  //method to update data updateData
  Future<void> updateData(
      String table, Map<String, dynamic> data, String idColumn) async {
    SimpleLogger.info("Updating data: $data");
    await _database?.update(table, data,
        where: '$idColumn = ?', whereArgs: [data[idColumn]]);
  }

  //method to localStorageService.getDataById('string', id)
  Future<Map<String, dynamic>> getDataById(String table, String id) async {
    SimpleLogger.info("Getting data by id: $id");
    final data =
        await _database?.query(table, where: 'id = ?', whereArgs: [id]);
    return data?.first ?? {};
  }

  Future<void> initDB() async {
    SimpleLogger.info("Initializing database");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        SimpleLogger.info("Creating database");
        // List of model names for which to create tables
        var modelNames = [
          'authorizations',
          'beacons',
          'companies',
          'dockings',
          'events',
          'logins',
          'portals',
          'receptors',
          'supervisors',
          'users',
          'vessels'
        ];
        SimpleLogger.info("Creating tables in the database");
        for (var modelName in modelNames) {
          SimpleLogger.info("Creating table for model: $modelName");
          var createTableSQL = createTableSQLForModel(modelName);
          if (createTableSQL.isNotEmpty) {
            SimpleLogger.info("Executing SQL: $createTableSQL");
            // Execute each create table statement
            await db.execute(createTableSQL);
          }
        }
      },
    );
  }

  String createTableSQLForModel(String modelName) {
    SimpleLogger.info("Creating table SQL for model: $modelName");
    switch (modelName) {
      case 'authorizations':
        return '''CREATE TABLE IF NOT EXISTS authorizations (
                id TEXT PRIMARY KEY, 
                userId TEXT, 
                vesselId TEXT, 
                expirationDate TEXT, 
                status TEXT
              )''';
      case 'beacons':
        return '''CREATE TABLE IF NOT EXISTS beacons (
                id TEXT PRIMARY KEY, 
                rssi INTEGER, 
                found TEXT, 
                userId TEXT, 
                updatedAt TEXT, 
                status TEXT
              )''';
      case 'companies':
        return '''CREATE TABLE IF NOT EXISTS companies (
                id TEXT PRIMARY KEY, 
                name TEXT, 
                logo TEXT, 
                supervisors TEXT, 
                vessels TEXT, 
                updatedAt TEXT, 
                expirationDate TEXT, 
                status TEXT
              )''';
      case 'dockings':
        return '''CREATE TABLE IF NOT EXISTS dockings (
                id TEXT PRIMARY KEY, 
                onboardedCount INTEGER, 
                dateStart TEXT, 
                dateEnd TEXT, 
                admins TEXT, 
                vesselId TEXT, 
                updatedAt TEXT, 
                draftMeters REAL, 
                status TEXT
              )''';
      case 'events':
        return '''CREATE TABLE IF NOT EXISTS events (
                id TEXT PRIMARY KEY,
                portalId TEXT,
                userId TEXT,
                timestamp TEXT,
                direction INTEGER,
                picture TEXT,
                vesselId TEXT,
                action INTEGER,
                manual INTEGER, -- Representing boolean as integer (0 = false, 1 = true)
                justification TEXT,
                createdAt TEXT,
                updatedAt TEXT,
                status TEXT
                )''';
      case 'logins':
        return '''CREATE TABLE IF NOT EXISTS logins (
                id TEXT PRIMARY KEY,
                userId TEXT,
                timestamp TEXT,
                expiration TEXT,
                system TEXT,
                createdAt TEXT,
                updatedAt TEXT,
                status TEXT
                )''';
      case 'portals':
        return '''CREATE TABLE IF NOT EXISTS portals (
                name TEXT,
                id TEXT PRIMARY KEY,
                vesselId TEXT,
                cameraStatus INTEGER,
                cameraIp TEXT,
                rfidStatus INTEGER,
                rfidIp TEXT,
                createdAt TEXT,
                updatedAt TEXT,
                status TEXT
                )''';
      case 'receptors':
        return '''CREATE TABLE IF NOT EXISTS receptors (
                id TEXT PRIMARY KEY,
                beacons TEXT, -- Assuming JSON encoded list or comma-separated values
                vessel TEXT,
                updatedAt TEXT,
                status TEXT
                )''';
      case 'supervisors':
        return '''CREATE TABLE IF NOT EXISTS supervisors (
                name TEXT,
                username TEXT,
                salt TEXT,
                hash TEXT,
                companyId TEXT,
                id TEXT PRIMARY KEY,
                updatedAt TEXT,
                status TEXT
                )''';
      case 'users':
        return '''CREATE TABLE IF NOT EXISTS users (
                id TEXT PRIMARY KEY,
                authorizationsId TEXT, -- Assuming JSON encoded list or comma-separated values
                name TEXT,
                company TEXT,
                role TEXT,
                project TEXT,
                number INTEGER,
                identidade TEXT,
                cpf TEXT,
                aso TEXT,
                asoDocument TEXT,
                hasAso INTEGER, -- Representing boolean as integer
                nr34 TEXT,
                nr34Document TEXT,
                hasNr34 INTEGER, -- Representing boolean as integer
                nr35 TEXT,
                nr35Document TEXT,
                hasNr35 INTEGER, -- Representing boolean as integer
                nr33 TEXT,
                nr33Document TEXT,
                hasNr33 INTEGER, -- Representing boolean as integer
                nr10 TEXT,
                nr10Document TEXT,
                hasNr10 INTEGER, -- Representing boolean as integer
                email TEXT,
                area TEXT,
                isAdmin INTEGER, -- Representing boolean as integer
                isVisitor INTEGER, -- Representing boolean as integer
                isGuardian INTEGER, -- Representing boolean as integer
                isOnboarded INTEGER, -- Representing boolean as integer
                isBlocked INTEGER, -- Representing boolean as integer
                blockReason TEXT,
                rfid TEXT,
                picture TEXT,
                createdAt TEXT,
                updatedAt TEXT,
                events TEXT, -- Assuming JSON encoded list or comma-separated values
                typeJob TEXT,
                startJob TEXT,
                endJob TEXT,
                username TEXT,
                salt TEXT,
                hash TEXT,
                status TEXT
                )''';
      case 'vessels':
        return '''CREATE TABLE IF NOT EXISTS vessels (
                name TEXT,
                companyId TEXT,
                updatedAt TEXT,
                id TEXT PRIMARY KEY,
                admins TEXT, -- Assuming JSON encoded list or comma-separated values
                onboardedCount INTEGER,
                portals TEXT, -- Assuming JSON encoded list or comma-separated values
                onboardedUsers TEXT, -- Assuming JSON encoded list or comma-separated values
                status TEXT
                )''';
      default:
        return '';
    }
  }

  Future<void> insertData(String table, Map<String, dynamic> data) async {
    SimpleLogger.info("Inserting data: $data");
    await _database?.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    SimpleLogger.info("Getting data from table: $table");
    return await _database?.query(table) ?? [];
  }

  Future<void> clearTable(String table) async {
    SimpleLogger.info("Clearing table: $table");
    await _database?.delete(table);
  }

  // ... (other methods)
  Future closeDB() async {
    SimpleLogger.info("Closing database");
    await _database?.close();
  }

  Future<List<String>> getIds(String table) async {
    SimpleLogger.info("Getting ids from table: $table");
    final List<Map<String, dynamic>> result =
        await _database?.query(table, columns: ['id']) ?? [];
    return result.map((item) => item['id'] as String).toList();
  }
}
