import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/maintenance_category_controller.dart';
import 'package:trackweaving/models/maintenance_alert_reponse.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({super.key});

  final MaintenanceCategoryController maintenanceCategoryController =
      Get.find<MaintenanceCategoryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'machine'.tr,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    maintenanceCategoryController.clearSelection();
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        value: maintenanceCategoryController.selectedAll.value,
                        onChanged: (value) {
                          maintenanceCategoryController
                              .selectAllMaintenanceEntry();
                        },
                      ),
                      Text(
                        maintenanceCategoryController.selectedAll.value
                            ? 'Deselect All'.tr
                            : 'Select All'.tr,
                        style: TextStyle(color: AppColors.mainColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  ...maintenanceCategoryController.maintenanceEntryList.map((
                    model,
                  ) {
                    MaintenanceEntryModel maintenanceEntryModel = model;

                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 4,
                        top: 4,
                      ),
                      child: InkWell(
                        onTap: () {
                          maintenanceCategoryController.selectMaintenanceEntry(
                            maintenanceEntryModel,
                          );
                        },
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 4,
                            top: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                maintenanceCategoryController
                                    .selectedMaintenanceEntry
                                    .contains(maintenanceEntryModel.machineId)
                                ? AppColors.mainColor.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                value: maintenanceCategoryController
                                    .selectedMaintenanceEntry
                                    .contains(maintenanceEntryModel.machineId),
                                onChanged: (value) {
                                  maintenanceCategoryController
                                      .selectMaintenanceEntry(
                                        maintenanceEntryModel,
                                      );
                                },
                              ),

                              Text(
                                maintenanceEntryModel.machineCode,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16.0),
            SizedBox(
              height: 46,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: AppColors.whiteColor,
                ),
                onPressed: () {
                  maintenanceCategoryController
                      .filterListByMachineCode(); //selectedMachineCode
                  Get.back();
                },
                child: Text(
                  'save'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
