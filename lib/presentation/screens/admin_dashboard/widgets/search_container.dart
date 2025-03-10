import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer(
      {required this.controller, required this.onSearch, super.key});

  final TextEditingController controller;
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.all(Radius.circular(17)),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 0.5,
        ),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: AppColors.primary,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
