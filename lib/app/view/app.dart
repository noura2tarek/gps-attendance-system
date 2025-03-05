import 'package:flutter/material.dart';
import 'package:gps_attendance_system/l10n/l10n.dart';
import 'package:gps_attendance_system/presentation/screens/auth/signup_page.dart';
import 'package:gps_attendance_system/core/app_routes.dart';
import 'package:gps_attendance_system/core/themes/app_theme.dart';
import 'package:gps_attendance_system/l10n/l10n.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/admin_home.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/employess_page.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/geofence_page.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/managers_page.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/pending_approvals_page.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/settings_page.dart';
import 'package:gps_attendance_system/presentaion/screens/admin_dashboard/total_leaves_page.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.adminHome,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case AppRoutes.adminHome:
            return MaterialPageRoute(builder: (context) => AdminHome());
          case AppRoutes.employees:
            return MaterialPageRoute(builder: (context) => EmployeesPage());
          case AppRoutes.managers:
            return MaterialPageRoute(builder: (context) => ManagersPage());
          case AppRoutes.geofence:
            return MaterialPageRoute(builder: (context) => GeofencePage());
          case AppRoutes.settings:
            return MaterialPageRoute(builder: (context) => SettingsPage());
          case AppRoutes.totalLeaves:
            return MaterialPageRoute(builder: (context) => TotalLeavesPage());
          case AppRoutes.pendingApprovals:
            return MaterialPageRoute(builder: (context) => PendingApprovalsPage());
          default:
            return MaterialPageRoute(builder: (context) => AdminHome());
        }
      },
    );
  }
}
