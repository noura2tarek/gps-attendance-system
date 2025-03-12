part of 'leaves_cubit.dart';

@immutable
sealed class LeavesState {}

final class LeavesInitial extends LeavesState {}

final class GetLeavesLoading extends LeavesState {}

final class LeavesLoaded extends LeavesState implements Equatable {
  final List<LeaveModel> totalLeaves;
  final List<LeaveModel> pendingLeaves;

  LeavesLoaded({required this.totalLeaves, required this.pendingLeaves});

  @override
  List<Object?> get props => [totalLeaves, pendingLeaves];

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LeavesError extends LeavesState implements Equatable {
  LeavesError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LeaveApplied extends LeavesState {}

final class LeaveUserDetailsLoaded extends LeavesState {}

final class LeaveApproved extends LeavesState {}
final class LeaveRejected extends LeavesState {}
