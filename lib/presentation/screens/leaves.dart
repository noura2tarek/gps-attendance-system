import 'package:flutter/material.dart';
import 'package:gps_attendance_system/presentation/screens/form_Page.dart';

class LeavesPage extends StatelessWidget {
  const LeavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApplyLeaveScreen(),
            ),
          );
        },
      ),
    );
  }
}
