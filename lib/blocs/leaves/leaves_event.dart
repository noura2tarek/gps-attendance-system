// leave_event.dart
part of 'leaves_bloc.dart'; // Link to leave_bloc.dart

abstract class LeaveEvent {}

// Event to fetch leaves from Firestore
class FetchLeaves extends LeaveEvent {}

// Event to filter leaves based on status
class FilterLeaves extends LeaveEvent {
  final String filter;

  FilterLeaves(this.filter);
}

// Event to update leaves when new data is received
class LeavesUpdated extends LeaveEvent {
  final List<LeaveModel> leaves;

  LeavesUpdated(this.leaves);
}

// Event to fetch the leave balance from Firestore
class FetchLeaveBalance extends LeaveEvent {}
