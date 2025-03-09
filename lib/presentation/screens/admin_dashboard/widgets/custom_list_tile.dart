import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    required this.title,
    this.subtitle,
    super.key,
    this.onTap,
    this.leadingWidget,
    this.isUser = true,
  });

  final String title;
  final String? subtitle;
  final void Function()? onTap;
  final bool isUser;
  final Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    double avatarRadius = MediaQuery.of(context).size.width * 0.07;
    return isUser
        ? Card(
            color: Colors.white.withValues(alpha: 0.9),
            surfaceTintColor: Colors.white,
            elevation: 1.5,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusColor: AppColors.secondary,
              hoverColor: AppColors.secondary,
              selectedColor: AppColors.secondary,
              iconColor: AppColors.thirdMintGreen,
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              subtitle: subtitle == null ? null : Text(subtitle ?? ''),
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: avatarRadius,
              ),
              onTap: onTap,
            ),
          )
        : ListTile(
            focusColor: AppColors.secondary,
            hoverColor: AppColors.secondary,
            selectedColor: AppColors.secondary,
            iconColor: AppColors.thirdMintGreen,
            title: Text(title),
            leading: leadingWidget,
            onTap: onTap,
          );
  }
}
