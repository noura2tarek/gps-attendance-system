import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
import 'package:gps_attendance_system/core/services/user_services.dart';

class LeaveService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a collection named leaves
  static final CollectionReference<Map<String, dynamic>> _leavesCollection =
      _firestore.collection('leaves');

  static Future<void> applyLeave(LeaveModel leave) async {
    try {
      await _leavesCollection.doc(leave.id).set(leave.toMap());
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

  // Accept leave service
  static Future<void> approveLeave(LeaveModel leave) async {
    // First: get the user id from the leave model
    final userId = leave.userId;
    // Second: Update the leave status in leaves document
    final leaveDocument = _leavesCollection.doc(leave.id);
    await leaveDocument.update({
      'status': 'Approved',
    });

    // Third: Update the leave balance of the user in the users collection
    final userDocument = UserService.users.doc(userId);
    final userData = await userDocument.get();
    var leaveBalance = UserModel.fromFirestore(userData).leaveBalance;
    if (leaveBalance > 0) {
      leaveBalance -=
          leave.endDate.toDate().difference(leave.startDate.toDate()).inDays +
              1;
      await userDocument.update({
        'isOnLeave': true,
        'leaveBalance': leaveBalance,
      });
      log('Leave Approved Successfully');
    }
  }

  // Reject leave service
  static Future<void> rejectLeave(LeaveModel leave) async {
    // Update the leave status in leaves document
    final leaveDocument = _leavesCollection.doc(leave.id);
    await leaveDocument.update({
      'status': 'unApproved',
    });
    log('Leave rejected');
  }
  
  // Get leaves by contact number
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
  // Update leave status
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
