import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_qr_googlemarine/utils/simple_logger.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('USER');

  Future<void> addUser(Map<String, dynamic> userMap) async {
    try {
      await _usersCollection.add(userMap);
      SimpleLogger.fine("User Added: ${userMap['name']}");
    } catch (error) {
      SimpleLogger.warning("Failed to add user: $error");
      throw Exception("Failed to add user");
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (error) {
      SimpleLogger.warning("Failed to fetch users: $error");
      throw Exception("Failed to fetch users");
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .where('nome', isGreaterThanOrEqualTo: query)
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (error) {
      SimpleLogger.warning("Failed to search users: $error");
      throw Exception("Failed to search users");
    }
  }
}
