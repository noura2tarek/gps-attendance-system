part of 'employee_location_cubit.dart';

@immutable
abstract class EmployeeLocationState {}

class EmployeeLocationInitial extends EmployeeLocationState {}

class EmployeeLocationInside extends EmployeeLocationState {}

class EmployeeLocationOutside extends EmployeeLocationState {}

class EmployeeLocationPermissionDenied extends EmployeeLocationState {}

class EmployeeLocationError extends EmployeeLocationState {
  final String message;
  EmployeeLocationError(this.message);
}