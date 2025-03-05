import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/widgets/custom_list_tile.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    required this.dummyEmployees, super.key,
  });

  final List<String> dummyEmployees;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dummyEmployees.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8),
          child: CustomListTile(
            // user name
            title: dummyEmployees[index],
            // user photo
            widget: const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 28,
            ),
          ),
        );
      },
    );
  }
}
