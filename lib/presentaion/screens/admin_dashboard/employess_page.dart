import 'package:flutter/material.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/widgets/search_container.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/widgets/users_list.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // list view of employees
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees Records'),
      ),
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            child: SearchContainer(),
          ),
          UsersList(
            dummyEmployees: [
              'John Doe',
              'Jane Doe',
              'John Doe',
              'Jane Doe',
              'John Doe',
              'Jane Doe',
              'Jane Doe',
              'Jane Doe',
              'Jane Doe',
              'Jane Doe',
              'Jane Doe',
            ],
          ),
        ],
      ),
    );
  }
}
