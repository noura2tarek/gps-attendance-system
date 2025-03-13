part of 'attendance_bloc.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class EmployeeLocationPermissionDenied extends AttendanceState {}

class EmployeeLocationInside extends AttendanceState {
  final DateTime checkInTime;
  final bool isOnTime;

  EmployeeLocationInside({required this.checkInTime, required this.isOnTime});
}

class EmployeeLocationOutside extends AttendanceState {}

class EmployeeCheckedIn extends AttendanceState {
  final String time;

  EmployeeCheckedIn({required this.time});
}

class EmployeeCheckedOut extends AttendanceState {
  final String checkOutTime;

  EmployeeCheckedOut({required this.checkOutTime});
}

class CompanyLocationUpdated extends AttendanceState {
  final double lat;
  final double lng;

  CompanyLocationUpdated(this.lat, this.lng);
}

class EmployeeLocationError extends AttendanceState {
  final String message;

  EmployeeLocationError(this.message);
}
