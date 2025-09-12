import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/dashboard_card.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _topRow(),
        SizedBox(height: 8),
        Divider(thickness: 1.2),
        Expanded(
          child: ListView(children: [DashboardCard(), SizedBox(height: 10)]),
        ),
      ],
    );
  }

  //top row
  Widget _topRow() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildRowItemBox(title: 'efficiency'.tr, value: '90%'),
            _buildRowItemBox(title: "picks".tr, value: "172937"),
            _buildRowItemBox(title: 'avg_picks'.tr, value: '43234'),
            _buildRowItemBox(title: 'avg_speed'.tr, value: '302'),
            _buildRowItemBox(title: 'running'.tr, value: '4'),
            _buildRowItemBox(title: 'stopped'.tr, value: '4'),
            _buildRowItemBox(title: 'all'.tr, value: '4', isRed: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItemBox({
    required String title,
    required String value,
    Function()? onTap,
    bool isRed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: titleStyle.copyWith(
                fontSize: 14,
                color: isRed ? AppColors.errorColor : null,
              ),
            ),
            Text(
              title,
              style: bodyStyle.copyWith(
                fontSize: 12,
                color: isRed ? AppColors.errorColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
