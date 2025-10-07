import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:trackweaving/models/part_changelog_list_response.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';

class MachinePartsListItem extends StatelessWidget {
  final PartChangeLog partChangeLog;
  final Function()? onTap;

  const MachinePartsListItem({
    super.key,
    required this.partChangeLog,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              buildRow(
                label: 'part_name'.tr,
                value: partChangeLog.partName,
                icon: Icons.construction_outlined,
              ),
              SizedBox(height: 4),
              buildRow(
                label: 'machine'.tr,
                value:
                    "${partChangeLog.machineId.machineName.capitalizeFirst} (${partChangeLog.machineId.machineCode})",
                icon: Icons.precision_manufacturing,
              ),
              SizedBox(height: 4),
              buildRow(
                label: 'changed_on'.tr,
                value: partChangeLog.changeDate.ddmmyyFormat,
                icon: Icons.date_range,
              ),
              SizedBox(height: 4),
              buildRow(
                label: 'change_name'.tr,
                value: partChangeLog.changedBy,

                icon: Icons.person,
              ),
              if (partChangeLog.changedByContact != null &&
                  partChangeLog.changedByContact!.isNotEmpty)
                SizedBox(height: 4),
              if (partChangeLog.changedByContact != null)
                buildRow(
                  label: 'change_phone'.tr,
                  value: partChangeLog.changedByContact ?? '',
                  icon: Icons.phone_android_outlined,
                ),
              if (partChangeLog.notes != null &&
                  partChangeLog.notes!.isNotEmpty)
                SizedBox(height: 4),
              if (partChangeLog.notes != null &&
                  partChangeLog.notes!.isNotEmpty)
                buildRow(
                  label: 'notes'.tr,
                  value: partChangeLog.notes,
                  icon: Icons.note,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildRow({String? label, String? value, IconData? icon}) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: AppColors.mainColor),

        const SizedBox(width: 12),
        if (label != null)
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        if (label != null) Spacer(),
        if (value != null)
          Text(value, style: TextStyle(fontSize: 14, color: Colors.black)),
      ],
    );
  }
}
