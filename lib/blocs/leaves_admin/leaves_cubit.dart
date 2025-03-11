import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/services/leave_service.dart';
import 'package:meta/meta.dart';

part 'leaves_state.dart';

class LeavesCubit extends Cubit<LeavesState> {
  LeavesCubit() : super(LeavesInitial());

  // static method to get cubit object
  static LeavesCubit get(BuildContext context) => BlocProvider.of(context);

  // Get all leaves from leaves service
  List<LeaveModel> allLeaves = [];
  List<LeaveModel> pendingLeaves = [];

  // Get all leaves method (stream)
  void getLeaves() {
    emit(GetLeavesLoading());
    try {
      LeaveService.getAllLeavesStream().listen((leaves) {
        allLeaves = leaves;
        pendingLeaves =
            allLeaves.where((leave) => leave.status == 'Pending').toList();
        emit(
          LeavesLoaded(
            totalLeaves: allLeaves,
            pendingLeaves: pendingLeaves,
          ),
        );
      });
    } catch (e) {
      emit(LeavesError(message: e.toString()));
    }
  }

  // Accept a leave
  Future<void> acceptLeave(LeaveModel leave) async {
    try {
      await LeaveService.approveLeave(leave);
      emit(LeaveStatusChanged());
    } catch (e) {
      emit(LeavesError(message: e.toString()));
    }
  }

  // Reject a leave
  Future<void> rejectLeave(LeaveModel leave) async {
    try {
      await LeaveService.rejectLeave(leave);
      emit(LeaveStatusChanged());
    } catch (e) {
      emit(LeavesError(message: e.toString()));
    }
  }
}
