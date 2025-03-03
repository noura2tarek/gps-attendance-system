import 'package:flutter/material.dart';
import 'package:gps_attendance_system/l10n/l10n.dart';
import 'package:gps_attendance_system/presentation/screens/user-check/check_in.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CheckIn(),
    );
  }
}
