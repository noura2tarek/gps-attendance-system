import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/attendance/attendance_bloc.dart';
import 'package:gps_attendance_system/core/utils/attendance_helper.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/buttons.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/company_location.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/details_card.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  void initState() {
    super.initState();
    print(AttendanceHelper.getAttendanceStatus("08:30 am"));
    context.read<AttendanceBloc>().add(CheckEmployeeLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
              bool isInside = false;
              bool hasCheckedIn = false;
              bool hasCheckedOut = false;
              String checkInTime = '--:--';
              String checkOutTime = '--:--';

              if (state is EmployeeLocationInside) {
                isInside = true;
              } else if (state is EmployeeCheckedIn) {
                hasCheckedIn = true;
                checkInTime = state.time;
              } else if (state is EmployeeCheckedOut) {
                hasCheckedOut = true;
                hasCheckedIn = false;
                checkOutTime = state.checkOutTime;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CheckInOutButton(
                        label: 'Check In',
                        color: isInside && !hasCheckedIn
                            ? Color(0XFF2563EB)
                            : Colors.black12,
                        onPressed: isInside && !hasCheckedIn
                            ? () =>
                                context.read<AttendanceBloc>().add(CheckIn())
                            : null,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CheckInOutButton(
                        label: 'Check Out',
                        color: hasCheckedIn
                            ? Color(0XFF203546)
                            : Color(0xff50B3C8),
                        onPressed: hasCheckedIn
                            ? () =>
                                context.read<AttendanceBloc>().add(CheckOut())
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Today's Attendance",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Detailscard(
                        title: 'Check In',
                        subtitle: checkInTime,
                        icon: Icons.login,
                        iconColor: const Color(0xff203546),
                      ),
                      Detailscard(
                        title: 'Check Out',
                        subtitle: checkOutTime,
                        icon: Icons.login,
                        iconColor: Color(0xff203546),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const CompanyLocation(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
