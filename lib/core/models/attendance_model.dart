import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String employeeId;
  final DateTime checkInTime;

  Attendance({required this.employeeId, required this.checkInTime});

  Map<String, dynamic> toFirestore() {
    return {
      'checkInTime': checkInTime.toIso8601String(),
    };
  }

  factory Attendance.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Attendance(
      employeeId: doc.id,
      checkInTime: DateTime.parse(data["checkInTime"] as String),
    );
  }
}
