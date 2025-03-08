part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckEmployeeLocation extends AttendanceEvent {}

class CheckIn extends AttendanceEvent {}

class CheckOut extends AttendanceEvent {}
