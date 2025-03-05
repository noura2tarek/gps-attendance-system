import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_attendance_system/presentaion/screens/home/cubits/employee_location_cubit.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/buttons.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/company_location.dart';
import 'package:gps_attendance_system/presentaion/screens/home/widgets/details_card.dart';


class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    context.read<EmployeeLocationCubit>().checkEmployeeLocation();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Location permission denied");
    } else {
      context.read<EmployeeLocationCubit>().checkEmployeeLocation();
    }
  }
  void checkIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<EmployeeLocationCubit, EmployeeLocationState>(
            builder: (context, state) {
              bool isInside = state is EmployeeLocationInside;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CheckInOutButton(
                        label: 'Check In',
                        color: isInside? Color(0XFF2563EB) : Colors.black12,
                        onPressed: checkIn,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CheckInOutButton(
                        label: 'Check Out',
                        color: const Color(0XFF203546),
                        onPressed: checkIn,
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Today's Attendance",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Detailscard(
                        title: 'Check In',
                        subtitle: '10:00',
                        icon: Icons.login,
                        iconColor: Color(0xff203546),
                      ),
                      Detailscard(
                        title: 'Check In',
                        subtitle: '10:00',
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
