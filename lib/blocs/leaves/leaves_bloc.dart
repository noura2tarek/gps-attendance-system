import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/services/leave_service.dart';
import 'package:gps_attendance_system/core/services/user_services.dart';

part 'leaves_event.dart';
part 'leaves_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  StreamSubscription? _leavesSubscription;
  int _leaveBalance = 25;
  LeaveBloc(LeaveService leaveService) : super(LeaveInitial()) {
    // 👇 Register ALL event handlers here!
    on<FetchLeaves>(_onFetchLeaves);
    on<FilterLeaves>(_onFilterLeaves);
    on<LeavesUpdated>(_onLeavesUpdated);
    on<FetchLeaveBalance>(_onFetchLeaveBalance);
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

        // Fetch leave balance after fetching leaves
        add(FetchLeaveBalance()); // Add this line
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
        leaveBalance: currentState.leaveBalance,
      ));
    }
  }

  void _onLeavesUpdated(LeavesUpdated event, Emitter<LeaveState> emit) {
    emit(LeaveLoaded(
      leaves: event.leaves,
      allLeaves: event.leaves,
    ));
  }

  void _onFetchLeaveBalance(
      FetchLeaveBalance event, Emitter<LeaveState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userData = await UserService.getUserData(userId);
        if (userData != null) {
          _leaveBalance = userData.leaveBalance;

          // Update the state with the new leave balance
          if (state is LeaveLoaded) {
            final currentState = state as LeaveLoaded;
            emit(LeaveLoaded(
              leaves: currentState.leaves,
              allLeaves: currentState.allLeaves,
              leaveBalance: _leaveBalance, // Update leave balance
            ));
          } else {
            emit(LeaveLoaded(
              leaves: [],
              allLeaves: [],
              leaveBalance: _leaveBalance, // Update leave balance
            ));
          }
        }
      }
    } catch (e) {
      emit(LeaveError(message: "Error fetching leave balance: $e"));
    }
  }

  @override
  Future<void> close() {
    _leavesSubscription?.cancel();
    return super.close();
  }
}
