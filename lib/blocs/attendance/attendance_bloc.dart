import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_attendance_system/core/utils/AttendanceStatusHelper.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  double? companyLat;
  double? companyLng;
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
    on<CompanyLocationFetched>(_onCompanyLocationFetched);
    _fetchCompanyLocation();
  }

  Future<void> _fetchCompanyLocation() async {
    try {
      final docSnapshot = await _firestore
          .collection('company-location')
          .doc('company-location')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        companyLat = data['latitude'] as double;
        companyLng = data['longitude'] as double;

        add(CompanyLocationFetched(companyLat!, companyLng!));
      } else {
        print('Company location document does not exist');
      }
    } catch (e) {
      print('Error fetching company location: $e');
    }
  }

  void _onCompanyLocationFetched(
      CompanyLocationFetched event, Emitter<AttendanceState> emit) {
    emit(CompanyLocationUpdated(event.lat, event.lng));
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
        companyLat!,
        companyLng!,
      );

      if (distance <= geofenceRadius) {
        DateTime now = DateTime.now();
        bool isOnTime = now.isBefore(officialCheckInTime);
        emit(EmployeeLocationInside(checkInTime: now, isOnTime: isOnTime));
      } else {
        print('User is outside the geofence');
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
      DocumentSnapshot doc = await attendanceDoc.get();
      String? previousCheckInTime = doc.exists ? (doc["checkInTime"] as String?) : null;

      await attendanceDoc.set({
        'checkOutTime': checkOutTime,
      }, SetOptions(merge: true));

      emit(EmployeeCheckedOut(checkOutTime: checkOutTime, previousCheckInTime: previousCheckInTime,));
    } catch (e) {
      emit(EmployeeLocationError('Failed to check out: $e'));
    }
  }
}
