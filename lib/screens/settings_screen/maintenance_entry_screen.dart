import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/screens/settings_screen/widgets/maintenance_entry_card.dart';
import 'package:get/get.dart';

class MaintenanceEntryScreen extends StatefulWidget {
  const MaintenanceEntryScreen({super.key});

  @override
  State<MaintenanceEntryScreen> createState() => _MaintenanceEntryScreenState();
}

class _MaintenanceEntryScreenState extends State<MaintenanceEntryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('maintenance_entry'.tr)),
      body: Column(
        children: [
          MaintenanceEntryCard(),
          SizedBox(height: 8),
          MaintenanceEntryCard(),
        ],
      ),
    );
  }
}
