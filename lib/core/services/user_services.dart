import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String uid, UserModel user) async {
    try {
      await _firestore.collection('users').doc(uid).set(user.toJson());
      print('User added successfully.');
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserModel.fromJson(docSnapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }
}
