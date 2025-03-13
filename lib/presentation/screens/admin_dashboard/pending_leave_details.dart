import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/leaves_admin/leaves_cubit.dart';
import 'package:gps_attendance_system/core/models/leave_model.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
import 'package:gps_attendance_system/core/services/user_services.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/custom_det_title.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/custom_row_details.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/custom_row_sections.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/my_divider.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';
import 'package:intl/intl.dart';

class PendingLeaveDetails extends StatefulWidget {
  const PendingLeaveDetails({required this.model, super.key});

  final LeaveModel model;

  @override
  State<PendingLeaveDetails> createState() => _PendingLeaveDetailsState();
}

class _PendingLeaveDetailsState extends State<PendingLeaveDetails> {
  UserModel? _userModel;

  _getUserData() async {
    _userModel = await UserService.getUserData(widget.model.userId);
    setState(() {});
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final startDate = dateFormat.format(widget.model.startDate.toDate());
    final endDate = dateFormat.format(widget.model.endDate.toDate());
    int noOfDays = widget.model.endDate
        .toDate()
        .difference(widget.model.startDate.toDate())
        .inDays;
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocListener<LeavesCubit, LeavesState>(
          listener: (context, state) {
            if (state is LeaveApproved) {
              CustomSnackBar.show(
                context,
                'Leave Approved Successfully',
                color: chooseSnackBarColor(ToastStates.SUCCESS),
              );
              Navigator.pop(context);
            } else if (state is LeaveRejected) {
              CustomSnackBar.show(
                context,
                'Leave Rejected Successfully',
                color: chooseSnackBarColor(ToastStates.SUCCESS),
              );
              Navigator.pop(context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.only(top: 8),
                child: CustomDetTitle(
                  text: 'User Details',
                ),
              ),
              // --- User Details
              CustomRowSections(
                text1: 'Leave Balance:',
                text2: 'Name:',
                text3: 'Role:',
                text4: 'Email:',
                text5: _userModel?.leaveBalance.toString() ?? '',
                text6: _userModel?.name ?? '',
                text7: stringFromRole(_userModel?.role ?? Role.admin),
                text8: _userModel?.email ?? '',
              ),
              //---- End of User Details
              const MyDivider(),
              const CustomDetTitle(
                text: 'Leave Details',
              ),
              //--- Leave Details
              CustomRowSections(
                text1: 'Leave Title:',
                text2: 'Leave Type:',
                text3: 'Reason:',
                text4: 'Status:',
                text5: widget.model.title,
                text6: widget.model.leaveType,
                text7: widget.model.reason,
                text8: widget.model.status,
              ),
              // Start & end date
              CustomRowDetails(
                title: '$startDate to $endDate',
                subtitle: '$noOfDays Day${noOfDays != 1 ? 's' : ''}',
              ),
              const MyDivider(),
              const Spacer(),
              //---- Approve and reject buttons ----//
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Approve button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.green),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        LeavesCubit.get(context).acceptLeave(widget.model);
                      },
                      child: const Text('Approve'),
                    ),
                  ),
                  // Reject button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.red,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        LeavesCubit.get(context).rejectLeave(widget.model);
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

////////////////////////////////////
