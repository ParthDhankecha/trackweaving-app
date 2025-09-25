import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/animated_active_switch.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/common_widgets/my_text_widget.dart';
import 'package:trackweaving/models/maintenance_category_list_model.dart';
import 'package:trackweaving/utils/app_colors.dart';

class MaintenanceCategoryCard extends StatelessWidget {
  final MaintenanceCategory maintenanceCategory;
  final int index;
  final Function(bool value) onChange;
  const MaintenanceCategoryCard({
    super.key,
    required this.maintenanceCategory,
    required this.index,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow('sr_no', '${index + 1}'),

                SizedBox(
                  width: 120,
                  child: AnimatedActiveSwitch(
                    current: maintenanceCategory.isActive,
                    onChanged: onChange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('category', maintenanceCategory.name),
            const SizedBox(height: 8),
            _buildInfoRow('type', maintenanceCategory.categoryType),
            const SizedBox(height: 8),
            _buildInfoRow(
              'schedule_days',
              '${maintenanceCategory.scheduleDays}',
            ),
            const SizedBox(height: 8),
            _buildInfoRow('alert_days', '${maintenanceCategory.alertDays}'),
            const SizedBox(height: 8),
            _buildInfoRow('alert_message', ''),
            const SizedBox(height: 2),
            MyTextWidget(
              text: maintenanceCategory.alertMessage,
              textColor: AppColors.errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyTextWidget(
          text: title,
          textStyle: bodyStyle1.copyWith(fontWeight: FontWeight.normal),
        ),
        SizedBox(width: 10),
        MyTextWidget(
          text: value,
          textStyle: bodyStyle.copyWith(color: color),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
