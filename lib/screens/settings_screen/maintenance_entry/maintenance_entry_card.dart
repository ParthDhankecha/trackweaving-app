import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/models/maintenance_alert_reponse.dart';
import 'package:trackweaving/screens/settings_screen/maintenance_entry/maintenance_entry_update.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';
import 'package:get/get.dart';

class MaintenanceEntryCard extends StatelessWidget {
  final MaintenanceEntryModel model;
  const MaintenanceEntryCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return //maintenance entry card
    Container(
      margin: EdgeInsets.only(left: 9, right: 9),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.successColor, width: 1.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.successColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.machineCode,
                    style: titleStyle.copyWith(color: Colors.white),
                  ),

                  Text(
                    model.machineName,
                    style: titleStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          //LIST OF ROWS
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: model.alerts.length,
            itemBuilder: (context, index) => _buildRow(
              title: model.alerts[index].categoryName,
              value: model.alerts[index].nextMaintenanceDate.ddmmyyFormat,
              isDue: model.alerts[index].isDue,
              onTap: () {
                Get.to(
                  () => MaintenanceEntryUpdate(
                    maintenanceEntryModel: model,
                    alert: model.alerts[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String title,
    required String value,
    required bool isDue,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: bodyStyle1.copyWith(color: Colors.black)),
                Text(
                  value,
                  style: bodyStyle.copyWith(
                    color: isDue ? Colors.red : AppColors.mainColor,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
