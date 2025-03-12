import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/leaves_admin/leaves_cubit.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/pending_approvals_page.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/leave_card.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TotalLeavesPage extends StatelessWidget {
  const TotalLeavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Leaves'),
      ),
      body: BlocBuilder<LeavesCubit, LeavesState>(
        builder: (context, state) {
          List<LeaveModel> allLeaves = LeavesCubit.get(context).allLeaves;
          if (state is LeavesLoaded) {
            allLeaves = state.totalLeaves;
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
                  final leave = allLeaves.isEmpty
                      ? dummyPendingLeaves[index]
                      : allLeaves[index];
                  final startDate = dateFormat.format(leave.startDate.toDate());
                  final endDate = dateFormat.format(leave.endDate.toDate());
                  int noOfDays = leave.endDate
                      .toDate()
                      .difference(leave.startDate.toDate())
                      .inDays;
                  return LeaveCard(
                    isTabbed: false,
                    startDate: startDate,
                    endDate: endDate,
                    leave: leave,
                    noOfDays: noOfDays,
                  );
                },
                itemCount: allLeaves.isEmpty
                    ? dummyPendingLeaves.length
                    : allLeaves.length,
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
