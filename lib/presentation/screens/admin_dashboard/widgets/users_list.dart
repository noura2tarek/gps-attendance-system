import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/user_details_page.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/custom_list_tile.dart';

class UsersList extends StatelessWidget {

  const UsersList({required this.employees, super.key});
  final List<String> employees;

  @override
  Widget build(BuildContext context) {
    double avatarRadius = MediaQuery.of(context).size.width * 0.08;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8),
          child: CustomListTile(
            title: employees[index],
            widget: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: avatarRadius,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserDetailsPage(userName: employees[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
