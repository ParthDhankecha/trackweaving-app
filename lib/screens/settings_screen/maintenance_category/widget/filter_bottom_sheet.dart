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
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    maintenanceCategoryController.clearSelection();
                    Get.back();
                  },
                  child: Text(
                    'clear_selection'.tr,
                    style: TextStyle(color: AppColors.errorColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...maintenanceCategoryController.maintenanceEntryList.map((model) {
              MaintenanceEntryModel maintenanceEntryModel = model;

              return InkWell(
                onTap: () {
                  maintenanceCategoryController.selectMaintenanceEntry(
                    maintenanceEntryModel,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        maintenanceEntryModel.machineCode,
                        style: TextStyle(fontSize: 16),
                      ),
                      maintenanceCategoryController.selectedMaintenanceEntry
                              .contains(maintenanceEntryModel.machineId)
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              );
              // return ListTile(
              //   title: Text(maintenanceEntryModel.machineCode),
              //   trailing:
              //       maintenanceCategoryController.selectedMaintenanceEntry
              //           .contains(maintenanceEntryModel.machineId)
              //       ? Icon(
              //           Icons.check_circle,
              //           color: Theme.of(context).primaryColor,
              //         )
              //       : null,
              //   onTap: () {
              //     maintenanceCategoryController.selectMaintenanceEntry(
              //       maintenanceEntryModel,
              //     );
              //   },
              // );
            }),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 34,

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
                child: Text('save'.tr, style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
