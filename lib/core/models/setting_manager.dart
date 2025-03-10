import 'package:flutter/material.dart';

class SettingsManager {
  factory SettingsManager() {
    return _instance;
  }

  SettingsManager._internal();

  static final SettingsManager _instance = SettingsManager._internal();

  void goToProfile(BuildContext context) {
    Navigator.pop(context);
  }
}
