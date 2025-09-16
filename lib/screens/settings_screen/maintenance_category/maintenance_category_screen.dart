import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/maintenance_category_controller.dart';
import 'package:flutter_texmunimx/models/maintenance_category_list_model.dart';
import 'package:flutter_texmunimx/screens/settings_screen/maintenance_category/maintenance_category_card.dart';
import 'package:get/get.dart';

class MaintenanceCategoryScreen extends StatefulWidget {
  const MaintenanceCategoryScreen({super.key});

  @override
  State<MaintenanceCategoryScreen> createState() =>
      _MaintenanceCategoryScreenState();
}

class _MaintenanceCategoryScreenState extends State<MaintenanceCategoryScreen> {
  MaintenanceCategoryController controller =
      Get.find<MaintenanceCategoryController>();

  @override
  void initState() {
    super.initState();
    controller.getMaintenanceCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('maintenance_category'.tr)),
      body: Column(
        children: [
          Obx(
            () => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.maintenanceList.length,
                      itemBuilder: (context, index) {
                        MaintenanceCategory maintenanceCategory =
                            controller.maintenanceList[index];
                        return MaintenanceCategoryCard(
                          maintenanceCategory: maintenanceCategory,
                          index: index,
                          onChange: (bool value) {
                            controller.changeCategoryStatus(
                              maintenanceCategory.id,
                              maintenanceCategory.isActive ? false : true,
                            );
                          },
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
