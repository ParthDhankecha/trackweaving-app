import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/controllers/dashboard_controller.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:get/get.dart';

class TopRowWidget extends StatelessWidget {
  TopRowWidget({super.key});

  final DashBoardController controller = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRowItemBox(
                title: 'efficiency'.tr,
                value: '${controller.eff.value}%',
              ),
              _buildRowItemBox(
                title: "picks".tr,
                value: controller.picks.value,
              ),
              _buildRowItemBox(
                title: 'avg_picks'.tr,
                value: controller.avgPick.value,
              ),
              _buildRowItemBox(
                title: 'avg_speed'.tr,
                value: controller.avgSpeed.value,
              ),
              _buildRowItemBox(
                title: 'running'.tr,
                value: controller.running.value,
              ),
              _buildRowItemBox(
                title: 'stopped'.tr,
                value: controller.stopped.value,
              ),
              _buildRowItemBox(
                title: 'all'.tr,
                value: controller.all.value,
                isRed: true,
              ),
            ],
          ),
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
