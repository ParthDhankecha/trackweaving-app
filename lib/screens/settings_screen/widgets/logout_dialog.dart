import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/controllers/home_controller.dart';
import 'package:trackweaving/controllers/login_controllers.dart';
import 'package:get/get.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout'.tr),
      content: Text('Are you sure you want to log out?'.tr),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.find<LoginControllers>().logout();
            Get.find<HomeController>().selectedNavIndex.value = 0;
            // Dismiss the dialog
            // Then navigate to the login screen
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text(
            'Logout'.tr,
            style: bodyStyle1.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
