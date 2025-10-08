import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/machine_search_dropdown.dart';
import 'package:trackweaving/controllers/maintenance_category_controller.dart';
import 'package:trackweaving/models/maintenance_alert_reponse.dart';
import 'package:trackweaving/screens/settings_screen/maintenance_category/widget/filter_bottom_sheet.dart';
import 'package:trackweaving/screens/settings_screen/maintenance_entry/maintenance_entry_card.dart';
import 'package:get/get.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/app_images.dart';

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
    controller.clearSelection();
    controller.getMaintenanceEntryList();
    controller.getMachineList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,

      appBar: AppBar(title: Text('alert'.tr)),
      body: Obx(
        () => controller.isLoading.value
            ? Column(children: [Center(child: CircularProgressIndicator())])
            : Column(
                children: [
                  Divider(height: 1, thickness: 0.2),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: MachineSearchDropdown(
                            title: 'select_machine'.tr,
                            selectedValues: controller.selectedMachines,
                            items: controller.availableMachines,
                            onChanged: (value) {
                              controller.updateSelectedMachines(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.filteredMaintenanceEntryList.length,
                      itemBuilder: (context, index) {
                        MaintenanceEntryModel model =
                            controller.filteredMaintenanceEntryList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: MaintenanceEntryCard(model: model),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
