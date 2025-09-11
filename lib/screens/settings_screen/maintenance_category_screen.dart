import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/screens/settings_screen/widgets/maintenance_category_card.dart';
import 'package:get/get.dart';

class MaintenanceCategoryScreen extends StatefulWidget {
  const MaintenanceCategoryScreen({super.key});

  @override
  State<MaintenanceCategoryScreen> createState() =>
      _MaintenanceCategoryScreenState();
}

class _MaintenanceCategoryScreenState extends State<MaintenanceCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('maintenance_category'.tr)),
      body: Column(
        children: [
          MaintenanceCategoryCard(
            srNo: '1',
            categoryName: 'Oil Change Due',
            type: 'Oil Change Due',
            scheduleDays: '365',
            alertDays: '5',
            status: true,
            alertMessage: 'Oil Change',
          ),
          MaintenanceCategoryCard(
            srNo: '1',
            categoryName: 'Oil Change Due',
            type: 'Oil Change Due',
            scheduleDays: '365',
            alertDays: '5',
            status: false,
            alertMessage:
                'Weft Sensor, Feeder & Color Selector Box To Be Cleaned With Air Pressure',
          ),
        ],
      ),
    );
  }
}
