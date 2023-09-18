import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_qr_googlemarine/models/user.dart';
import 'package:cripto_qr_googlemarine/utils/simple_logger.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('USER');

  Future<void> addUser(Map<String, dynamic> userMap) async {
    try {
      await _usersCollection.add(userMap);
      SimpleLogger.fine("User Added: ${userMap['name']}");
    } on FirebaseException catch (error) {
      SimpleLogger.warning("Failed to add user: $error");
      throw Exception("Failed to add user");
    } on Exception catch (error) {
      SimpleLogger.warning("Failed to add user: $error");
      throw Exception("Failed to add user");
    }
  }

  Future<User> fetchLastUser() async {
    try {
      SimpleLogger.info("Fetching last user");
      QuerySnapshot querySnapshot = await _usersCollection
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      var data = querySnapshot.docs[0].data() as Map<String, dynamic>;
      return User.fromMap(data);
    } on FirebaseException catch (error) {
      SimpleLogger.warning("Failed to fetch last user: $error");
      throw Exception("Failed to fetch last user");
    } catch (error) {
      SimpleLogger.warning("Failed to fetch last user: $error");
      throw Exception("Failed to fetch last user");
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      SimpleLogger.info("Fetching users");
      QuerySnapshot querySnapshot = await _usersCollection.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } on FirebaseException catch (error) {
      SimpleLogger.warning("Failed to fetch users: $error");
      throw Exception("Failed to fetch users");
    } catch (error) {
      SimpleLogger.warning("Failed to fetch users: $error");
      throw Exception("Failed to fetch users");
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      SimpleLogger.info("Searching users");

      List<Map<String, dynamic>> results = [];

      if (RegExp(r'^\d+$').hasMatch(query)) {
        QuerySnapshot querySnapshotIdentidade =
            await _usersCollection.where('identidade', isEqualTo: query).get();
        results = querySnapshotIdentidade.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else {
        QuerySnapshot querySnapshotNome = await _usersCollection
            .where('nome', isGreaterThanOrEqualTo: query)
            .get();
        results = querySnapshotNome.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }

      print(results);

      return results;
    } catch (error) {
      SimpleLogger.warning("Failed to search users: $error");
      throw Exception("Failed to search users");
    }
  }

  Future<int> fetchNumero() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .orderBy('numero', descending: true)
          .limit(1)
          .get();
      print(querySnapshot.docs[0].data());
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs[0].data() as Map<String, dynamic>;
        return data != null && data['numero'] != null
            ? data['numero'] as int
            : 9999;
      } else {
        return 9999;
      }
    } catch (error) {
      SimpleLogger.warning("Failed to fetch numero: $error");
      throw Exception("Failed to fetch numero");
    }
  }
}
