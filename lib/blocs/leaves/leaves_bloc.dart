import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/services/leave_service.dart';
import 'package:gps_attendance_system/core/services/user_services.dart';

part 'leaves_event.dart';
part 'leaves_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  StreamSubscription? _leavesSubscription;

  LeaveBloc(LeaveService leaveService) : super(LeaveInitial()) {
    // 👇 Register ALL event handlers here!
    on<FetchLeaves>(_onFetchLeaves);
    on<FilterLeaves>(_onFilterLeaves);
    on<LeavesUpdated>(_onLeavesUpdated);
  }

  void _onFetchLeaves(FetchLeaves event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    try {
      final contactNumber = await UserService.getCurrentUserContactNumber();
      print("Fetched contact number: $contactNumber");

      if (contactNumber != null) {
        // Cancel previous subscription
        await _leavesSubscription?.cancel();

        // Listen to the stream
        _leavesSubscription =
            LeaveService.getLeavesByContactNumber(contactNumber).listen(
                (leaves) {
          print("Received real-time update: ${leaves.length} leaves");
          add(LeavesUpdated(leaves));
        }, onError: (error) {
          print("Error receiving leaves: $error");
          emit(LeaveError(message: "Error receiving leaves: $error"));
        });
      } else {
        emit(LeaveError(message: "Contact number not found"));
      }
    } catch (e) {
      emit(LeaveError(message: e.toString()));
    }
  }

  void _onFilterLeaves(FilterLeaves event, Emitter<LeaveState> emit) {
    if (state is LeaveLoaded) {
      final currentState = state as LeaveLoaded;

      final filteredLeaves = event.filter == 'All'
          ? currentState.allLeaves
          : currentState.allLeaves
              .where((leave) => leave.status == event.filter)
              .toList();

      emit(LeaveLoaded(
        leaves: filteredLeaves,
        allLeaves: currentState.allLeaves,
      ));
    }
  }

  void _onLeavesUpdated(LeavesUpdated event, Emitter<LeaveState> emit) {
    emit(LeaveLoaded(
      leaves: event.leaves,
      allLeaves: event.leaves,
    ));
  }

  @override
  Future<void> close() {
    _leavesSubscription?.cancel();
    return super.close();
  }
}
