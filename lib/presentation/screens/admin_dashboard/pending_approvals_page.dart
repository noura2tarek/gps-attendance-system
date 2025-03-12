import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/leaves_admin/leaves_cubit.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/pending_leave_details.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

// dummy leaves
List<LeaveModel> dummyPendingLeaves = [
  LeaveModel(
    title: 'Casual',
    leaveType: 'Casual Leave',
    contactNumber: '01062197942',
    startDate: Timestamp.fromDate(DateTime.now()),
    endDate: Timestamp.fromDate(DateTime.now()),
    reason: 'this reason',
    userId: FirebaseAuth.instance.currentUser!.uid,
    id: '4444',
  ),
  LeaveModel(
    title: 'Casual',
    leaveType: 'Casual Leave',
    contactNumber: '01062197942',
    startDate: Timestamp.fromDate(DateTime.now()),
    endDate: Timestamp.fromDate(DateTime.now()),
    reason: 'this reason',
    userId: FirebaseAuth.instance.currentUser!.uid,
    id: '4444',
  ),
];

class PendingApprovalsPage extends StatelessWidget {
  const PendingApprovalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Approvals'),
      ),
      body: BlocBuilder<LeavesCubit, LeavesState>(
        builder: (context, state) {
          List<LeaveModel> pendingLeaves = [];
          if (state is LeavesLoaded) {
            pendingLeaves = state.pendingLeaves;
          }
          if (state is LeavesError) {
            CustomSnackBar.show(
              context,
              state.message,
              color: chooseSnackBarColor(ToastStates.ERROR),
            );
          }
          // Date formatter
          final dateFormat = DateFormat('yyyy-MM-dd');
          return Skeletonizer(
            enabled: state is GetLeavesLoading,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 16),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final leave = pendingLeaves.isEmpty
                      ? dummyPendingLeaves[index]
                      : pendingLeaves[index];
                  final startDate = dateFormat.format(leave.startDate.toDate());
                  final endDate = dateFormat.format(leave.endDate.toDate());
                  int noOfDays = leave.endDate
                      .toDate()
                      .difference(leave.startDate.toDate())
                      .inDays;
                  return PendingLeaveCard(
                    startDate: startDate,
                    endDate: endDate,
                    leave: leave,
                    noOfDays: noOfDays,
                  );
                },
                itemCount: pendingLeaves.isEmpty
                    ? dummyPendingLeaves.length
                    : pendingLeaves.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

///////////////////////////////
class PendingLeaveCard extends StatelessWidget {
  const PendingLeaveCard({
    required this.startDate,
    required this.endDate,
    required this.leave,
    required this.noOfDays,
    super.key,
  });

  final String startDate;
  final String endDate;
  final LeaveModel leave;
  final int noOfDays;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // on tab: go to leave details
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PendingLeaveDetails(
              model: leave,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //-------- Title and status row ------------//
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leave.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.lightOrangeColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      leave.status,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              // divider
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Divider(
                  height: 3,
                ),
              ),
              // Start & end date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$startDate to $endDate',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  // Duration
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 5),
                    child: Text(
                      '$noOfDays Day${noOfDays != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              // leave type
              Text(
                leave.leaveType,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black2Color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
