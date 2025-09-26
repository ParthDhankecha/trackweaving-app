import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/controllers/dashboard_controller.dart';
import 'package:trackweaving/models/status_enum.dart';
import 'package:trackweaving/utils/app_colors.dart';
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
              SizedBox(width: 6),
              _buildRowItemBox(
                title: "picks".tr,
                value: controller.picks.value,
              ),
              SizedBox(width: 6),

              _buildRowItemBox(
                title: 'avg_picks'.tr,
                value: controller.avgPick.value,
              ),
              SizedBox(width: 6),

              _buildRowItemBox(
                title: 'avg_speed'.tr,
                value: controller.avgSpeed.value,
              ),
              SizedBox(width: 4),
              Container(height: 30, width: 1.8, color: Colors.grey),
              SizedBox(width: 4),

              _buildRowItemBox(
                title: 'running'.tr,
                color: controller.currentStatus.value == MachineStatus.running
                    ? AppColors.successColor
                    : null,
                value: controller.running.value,
                isActive:
                    controller.currentStatus.value == MachineStatus.running,
                onTap: () {
                  controller.changeStatus(MachineStatus.running);
                },
              ),
              SizedBox(width: 6),

              _buildRowItemBox(
                title: 'stopped'.tr,
                value: controller.stopped.value,
                isActive:
                    controller.currentStatus.value == MachineStatus.stopped,
                onTap: () => controller.changeStatus(MachineStatus.stopped),
                color: controller.currentStatus.value == MachineStatus.stopped
                    ? AppColors.errorColor
                    : null,
              ),

              SizedBox(width: 6),

              _buildRowItemBox(
                title: 'all'.tr,
                value: controller.all.value,
                isActive: controller.currentStatus.value == MachineStatus.all,
                onTap: () => controller.changeStatus(MachineStatus.all),
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
    Color? color,

    bool isActive = false,
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
              style: GoogleFonts.poppins(
                fontSize: isActive ? 14 : 12,
                color: color ?? AppColors.mainColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: color ?? AppColors.mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
