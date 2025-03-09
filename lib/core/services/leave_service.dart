import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';

class LeaveService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> applyLeave(LeaveModel leave) async {
  //   try {
  //     await _firestore
  //         .collection('users')
  //         .doc(leave.userId)
  //         .collection('leaves')
  //         .doc(leave.id)
  //         .set(leave.toMap());
  //     print("Leave Applied Successfully");
  //   } catch (e) {
  //     print("Error applying leave: $e");
  //   }
  // }
  static Future<void> applyLeave(LeaveModel leave) async {
    final userId = leave.userId;
    try {
      await _firestore.collection('leaves').doc(userId).set(leave.toMap());
      print('Leave Applied Successfully');
    } catch (e) {
      print('Error applying leave: $e');
    }
  }
}
