
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gps_attendance_system/core/models/user_attendance.dart';

class UserAttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAttendance(UserAttendance attendance) async {
    try {
      await _firestore
          .collection('user-attendance')
          .doc(attendance.employeeId)
          .collection('attendance')
          .doc(DateTime.now().toString())
          .set(attendance.toFirestore());
    } catch(e){
      print(e);
    }
  }
}