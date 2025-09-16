import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/maintenance_category_controller.dart';
import 'package:flutter_texmunimx/models/maintenance_alert_reponse.dart';
import 'package:flutter_texmunimx/screens/settings_screen/maintenance_entry/maintenance_entry_card.dart';
import 'package:get/get.dart';

class MaintenanceEntryScreen extends StatefulWidget {
  const MaintenanceEntryScreen({super.key});

  @override
  State<MaintenanceEntryScreen> createState() => _MaintenanceEntryScreenState();
}

class _MaintenanceEntryScreenState extends State<MaintenanceEntryScreen> {
  MaintenanceCategoryController controller =
      Get.find<MaintenanceCategoryController>();

  @override
  void initState() {
    super.initState();
    controller.getMaintenanceEntryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('maintenance_entry'.tr)),
      body: Column(
        children: [
          Obx(
            () => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.maintenanceEntryList.length,
                      itemBuilder: (context, index) {
                        MaintenanceEntryModel model =
                            controller.maintenanceEntryList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: MaintenanceEntryCard(model: model),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
