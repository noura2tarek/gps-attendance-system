import 'package:flutter/widgets.dart';
import 'package:gps_attendance_system/presentaion/widgets/buttons.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  void checkIn() {}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CheckInOutButton(
                label: 'Check In',
                color: const Color(0XFF2563EB),
                onPressed: checkIn,
              ),
              CheckInOutButton(
                label: 'Check Out',
                color: const Color(0XFF203546),
                onPressed: checkIn,
              ),
            ],
          )
        ],
      ),
    );
  }
}
