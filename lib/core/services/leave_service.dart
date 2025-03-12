import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';

class LeaveService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a collection named leaves
  static final CollectionReference<Map<String, dynamic>> _leavesCollection =
      _firestore.collection('leaves');

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
    //final userId = leave.userId;
    try {
      await _leavesCollection.add(leave.toMap());
      print('Leave Applied Successfully');
    } catch (e) {
      print('Error applying leave: $e');
    }
  }

  // Get all leaves
  static Stream<List<LeaveModel>> getAllLeavesStream() {
    return _leavesCollection.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => LeaveModel.fromFirestore(doc))
              .toList(),
        );
  }

  static Stream<List<LeaveModel>> getLeavesByContactNumber(
      String contactNumber) {
    return _leavesCollection
        .where('contactNumber', isEqualTo: contactNumber)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LeaveModel.fromFirestore(doc))
              .toList(),
        );
  }

  static Future<void> updateLeaveStatus(
      String leaveId, String newStatus) async {
    try {
      await _leavesCollection.doc(leaveId).update({'status': newStatus});
      print('Leave status updated successfully');
    } catch (e) {
      print('Error updating leave status: $e');
    }
  }
}
