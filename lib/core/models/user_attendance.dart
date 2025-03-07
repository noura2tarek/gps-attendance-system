import 'package:cloud_firestore/cloud_firestore.dart';

class UserAttendance {
  final String employeeId;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String status;

  UserAttendance({
    required this.employeeId,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
  });

  factory UserAttendance.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserAttendance(
      employeeId: data?['employeeId']?.toString() ?? '',
      checkInTime: data?['checkInTime'] != null
          ? (data?['checkInTime'] as Timestamp).toDate()
          : null,
      checkOutTime: data?['checkOutTime'] != null
          ? (data?['checkOutTime'] as Timestamp).toDate()
          : null,
      status: data?['status']?.toString() ?? 'Unknown',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'employeeId': employeeId,
      if (checkInTime != null) 'checkInTime': checkInTime,
      if (checkOutTime != null) 'checkOutTime': checkOutTime,
      'status': status,
    };
  }
}
