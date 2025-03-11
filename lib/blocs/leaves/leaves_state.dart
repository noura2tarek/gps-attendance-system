// leave_state.dart
part of 'leaves_bloc.dart';

abstract class LeaveState {}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveLoaded extends LeaveState {
  final List<LeaveModel> leaves; // Filtered leaves
  final List<LeaveModel> allLeaves; // Original list of leaves

  LeaveLoaded({required this.leaves, required this.allLeaves});
}

class LeaveError extends LeaveState {
  final String message;

  LeaveError({required this.message});
}
