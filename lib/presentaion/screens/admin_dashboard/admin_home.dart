import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/app_routes.dart';
import 'package:gps_attendance_system/core/app_strings.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/widgets/custom_container.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/widgets/custom_list_tile.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/widgets/search_container.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/widgets/users_list.dart';
import 'package:intl/intl.dart';

DateTime date = DateTime.now();
//format using intl package
DateFormat format = DateFormat('EEE, dd MMM');

String formattedDate = format.format(date);

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final List<String> containerTitles = [
    'Employees',
    'Managers',
  ];
  final List<String> headerTitles = [
    AppStrings.dashboard,
    AppStrings.employees,
    AppStrings.managers,
    AppStrings.geofence,
    AppStrings.settings,
    AppStrings.logout,
  ];
  final List<String> dummyEmployees = [
    'Robert Morgan',
    'Ahmed Fox',
    'John Doe',
    'Jacob Smith',
    'Jacob Smith',
    'Jacob Smith',
    'Jacob Smith',
  ];
  final List<IconData> headerIcons = [
    Icons.dashboard,
    Icons.person,
    Icons.supervisor_account,
    Icons.location_on,
    Icons.settings,
    Icons.logout,
  ];
  final List<IconData> containerIcons = [
    Icons.people,
    Icons.supervisor_account,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        foregroundColor: AppColors.blackColor,
        backgroundColor: AppColors.whiteColor,
        elevation: 1,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      // Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header includes title and date
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Admin name
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Hello, Admin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                  // Admin photo
                  const CircleAvatar(
                    backgroundColor: AppColors.whiteColor,
                    radius: 28,
                  ),
                ],
              ),
            ),
            // Dashboard list tiles
            // closes the drawer if the required page is opened
            ...List.generate(
              headerTitles.length,
              (index) {
                return CustomListTile(
                  title: headerTitles[index],
                  widget: Icon(
                    headerIcons[index],
                    color: AppColors.blackColor,
                  ),
                  onTap: () {
                    if (index == 0) {
                      Navigator.pop(context);
                    } else if (index == 1) {
                      Navigator.pushNamed(context, AppRoutes.employees);
                    } else if (index == 2) {
                      Navigator.pushNamed(context, AppRoutes.managers);
                    } else if (index == 3) {
                      Navigator.pushNamed(context, AppRoutes.geofence);
                    } else if (index == 4) {
                      Navigator.pushNamed(context, AppRoutes.settings);
                    } else if (index == 5) {
                      // log out logic here
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(12),
        child: ListView(
          children: [
            // overview title
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 10),
            // overview cards Gridview
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 8,
              ),
              itemCount: containerTitles.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CustomContainer(
                  containerTitles: containerTitles,
                  icons: containerIcons,
                  index: index,
                );
              },
            ),
            const SizedBox(height: 20),
            // Employee list title
            const Row(
              children: [
                Icon(Icons.people),
                SizedBox(width: 10),
                Text(
                  'Employees List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Search bar container
            const SearchContainer(),
            const SizedBox(height: 14),
            // Employee list view
            UsersList(dummyEmployees: dummyEmployees),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////
