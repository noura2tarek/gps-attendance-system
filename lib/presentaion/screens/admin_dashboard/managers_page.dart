import 'package:flutter/material.dart';

class ManagersPage extends StatelessWidget {
  const ManagersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // list view all managers
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Managers Records'),),
    );
  }
}
