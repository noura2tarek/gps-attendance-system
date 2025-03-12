import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/leaves_admin/leaves_cubit.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';

class PendingLeaveDetails extends StatelessWidget {
  const PendingLeaveDetails({required this.model, super.key});

  final LeaveModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<LeavesCubit, LeavesState>(
          listener: (context, state) {
            if (state is LeaveApproved) {
               CustomSnackBar.show(context, 'Leave Approved Successfully',
                  color: chooseSnackBarColor(ToastStates.SUCCESS));
              Navigator.pop(context);
            } else if (state is LeaveRejected) {
              CustomSnackBar.show(context, 'Leave Approved Successfully',
                  color: chooseSnackBarColor(ToastStates.SUCCESS));
              Navigator.pop(context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('name'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 19,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    model.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Divider(),
              // Approve and reject buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.green),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                      onPressed: () {
                        LeavesCubit.get(context).acceptLeave(model);
                      },
                      child: const Text('Approve'),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            Colors.red,
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                      onPressed: () {
                        LeavesCubit.get(context).rejectLeave(model);
                      },
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
