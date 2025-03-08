import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_attendance_system/blocs/attendance/attendance_bloc.dart';
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
import 'package:gps_attendance_system/presentaion/screens/auth/login_page.dart';
import 'package:gps_attendance_system/presentaion/screens/leaves.dart';
import 'package:gps_attendance_system/presentaion/screens/home/check_in.dart';
import 'package:gps_attendance_system/presentaion/screens/home/cubits/employee_location_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AttendanceBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppRoutes.userHome,
        home: LoginPage(),
      ),
    );
  }
}
