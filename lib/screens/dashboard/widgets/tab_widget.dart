import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/controllers/dashboard_controller.dart';
import 'package:trackweaving/models/status_enum.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:get/get.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DashBoardController controller = Get.find<DashBoardController>();
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabItem(
            title: 'Running',
            value: controller.running.value,
            onTap: () {
              controller.changeStatus(MachineStatus.running);
            },
            isSelected: controller.currentStatus.value == MachineStatus.running,
            isLeftBtn: true,
          ),
          _tabItem(
            title: 'Stopped',
            value: controller.stopped.value,
            onTap: () {
              controller.changeStatus(MachineStatus.stopped);
            },
            isSelected: controller.currentStatus.value == MachineStatus.stopped,
          ),

          _tabItem(
            title: 'All',
            value: controller.all.value,
            onTap: () {
              controller.changeStatus(MachineStatus.all);
            },
            isSelected: controller.currentStatus.value == MachineStatus.all,
            isRight: true,
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String title,
    required String value,
    required Function() onTap,
    required bool isSelected,
    bool isLeftBtn = false,
    bool isRight = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.mainColor : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: isLeftBtn
              ? BorderRadiusGeometry.only(
                  topLeft: isLeftBtn ? Radius.circular(12) : Radius.circular(0),
                  bottomLeft: isLeftBtn
                      ? Radius.circular(12)
                      : Radius.circular(0),
                )
              : isRight
              ? BorderRadiusGeometry.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )
              : BorderRadiusGeometry.zero,
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Text(
              title,
              style: bodyStyle1.copyWith(
                color: isSelected ? Colors.white : AppColors.mainColor,
              ),
            ),
            Text(
              value,
              style: bodyStyle.copyWith(
                color: isSelected ? Colors.white : AppColors.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
