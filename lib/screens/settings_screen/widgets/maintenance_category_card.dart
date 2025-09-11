import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/my_text_widget.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';

class MaintenanceCategoryCard extends StatelessWidget {
  final String srNo;
  final String categoryName;
  final String type;
  final String scheduleDays;
  final String alertDays;
  final bool status;
  final String alertMessage;

  const MaintenanceCategoryCard({
    super.key,
    required this.srNo,
    required this.categoryName,
    required this.type,
    required this.scheduleDays,
    required this.alertDays,
    required this.status,
    required this.alertMessage,
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
                _buildInfoRow('sr_no', srNo.toString()),
                Container(
                  decoration: BoxDecoration(
                    color: status ? Colors.green : Colors.deepOrange,

                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: MyTextWidget(
                      text: status ? 'active' : 'inactive',
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('category', categoryName),
            const SizedBox(height: 8),
            _buildInfoRow('type', type),
            const SizedBox(height: 8),
            _buildInfoRow('schedule_days', scheduleDays),
            const SizedBox(height: 8),
            _buildInfoRow('alert_days', alertDays),
            const SizedBox(height: 8),
            _buildInfoRow('alert_message', ''),
            const SizedBox(height: 2),
            MyTextWidget(text: alertMessage, textColor: AppColors.errorColor),
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
