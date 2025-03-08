import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_attendance_system/core/utils/AttendanceStatusHelper.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final double companyLat = 30.0447;
  final double companyLng = 31.2389;
  final double geofenceRadius = 100;
  static final DateTime officialCheckInTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    9,
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AttendanceBloc() : super(AttendanceInitial()) {
    on<CheckEmployeeLocation>(_onCheckEmployeeLocation);
    on<CheckIn>(_onCheckIn);
    on<CheckOut>(_onCheckOut);
  }

  Future<void> _onCheckEmployeeLocation(
    CheckEmployeeLocation event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        emit(EmployeeLocationPermissionDenied());
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        companyLat,
        companyLng,
      );

      if (distance <= geofenceRadius) {
        DateTime now = DateTime.now();
        bool isOnTime = now.isBefore(officialCheckInTime);
        emit(EmployeeLocationInside(checkInTime: now, isOnTime: isOnTime));
      } else {
        emit(EmployeeLocationOutside());
      }
    } catch (e) {
      emit(EmployeeLocationError("Error checking location: $e"));
    }
  }

  Future<void> _onCheckIn(CheckIn event, Emitter<AttendanceState> emit) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(EmployeeLocationError("User not found"));
      return;
    }

    final now = DateTime.now();
    final todayDate = "${now.year}-${now.month}-${now.day}";
    final checkInTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final status = AttendanceStatusHelper.getStatus(now);
    final attendanceDoc = _firestore
        .collection('attendanceRecords')
        .doc('${user.uid}_$todayDate');
    try {
      await attendanceDoc.set(
        {
          "userId": user.uid,
          "date": todayDate,
          "checkInTime": checkInTime,
          "status": status,
        },
        SetOptions(merge: true),
      );

      emit(EmployeeCheckedIn(time: checkInTime));
    } catch (e) {
      emit(EmployeeLocationError('Failed to check in: $e'));
    }
  }

  Future<void> _onCheckOut(
    CheckOut event,
    Emitter<AttendanceState> emit,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(EmployeeLocationError('User not found'));
      return;
    }

    final now = DateTime.now();
    final todayDate = '${now.year}-${now.month}-${now.day}';
    final checkOutTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final attendanceDoc = _firestore
        .collection('attendanceRecords')
        .doc('${user.uid}_$todayDate');

    try {
      await attendanceDoc.set({
        'checkOutTime': checkOutTime,
      }, SetOptions(merge: true));

      emit(EmployeeCheckedOut(checkOutTime: checkOutTime));
    } catch (e) {
      emit(EmployeeLocationError('Failed to check out: $e'));
    }
  }
}
