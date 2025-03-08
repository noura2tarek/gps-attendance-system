import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/app_routes.dart';
import 'package:gps_attendance_system/core/models/user_model.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';
import 'package:gps_attendance_system/presentation/screens/admin_dashboard/widgets/custom_list_tile.dart';

class UsersList extends StatelessWidget {
  const UsersList({required this.users, super.key});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    double avatarRadius = MediaQuery.of(context).size.width * 0.08;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8),
          child: CustomListTile(
            title: users[index].name,
            widget: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: avatarRadius,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.userDetailsRoute,
                arguments: users[index],
              );
            },
          ),
        );
      },
    );
  }
}
