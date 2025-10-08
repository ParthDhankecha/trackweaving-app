import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/controllers/login_controllers.dart';
import 'package:trackweaving/screens/settings_screen/machine_configuration/machine_configuration_screen.dart';
import 'package:trackweaving/screens/settings_screen/machine_group/machine_group_screen.dart';
import 'package:trackweaving/screens/settings_screen/machine_parts/machine_parts_screen.dart';
import 'package:trackweaving/screens/settings_screen/maintenance_category/maintenance_category_screen.dart';
import 'package:trackweaving/screens/settings_screen/maintenance_entry/maintenance_entry_screen.dart';
import 'package:trackweaving/screens/settings_screen/shift_comments/shift_comments.dart';
import 'package:trackweaving/screens/settings_screen/users/user_list_screen.dart';
import 'package:trackweaving/screens/settings_screen/widgets/language_bottom_sheet.dart';
import 'package:trackweaving/screens/settings_screen/widgets/logout_dialog.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/app_images.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LoginControllers loginController = Get.find<LoginControllers>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        title: Text('settings'.tr),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(height: 1, thickness: 0.2),
            SizedBox(height: 20),
            _settingsRow(
              title: 'machine_group',
              image: AppImages.imgSettings,
              onTap: () => Get.to(() => MachineGroupScreen()),
            ),
            Divider(),
            _settingsRow(
              title: 'machine_configure',
              image: AppImages.imgSettings1,
              onTap: () => Get.to(() => MachineConfigurationScreen()),
            ),
            Divider(),
            _settingsRow(
              title: 'maintenance_category',
              icon: Icons.list_alt_outlined,
              onTap: () => Get.to(() => MaintenanceCategoryScreen()),
            ),
            Divider(),
            _settingsRow(
              title: 'maintenance_entry',
              icon: Icons.add,
              onTap: () => Get.to(() => MaintenanceEntryScreen()),
            ),
            Divider(),
            _settingsRow(
              title: 'shift_wise_comment_update',
              icon: Icons.list,
              onTap: () => Get.to(() => ShiftComments()),
            ),

            Divider(),

            _settingsRow(
              title: 'parts_change_entry',
              icon: Icons.construction_outlined,
              onTap: () => Get.to(() => MachinePartsScreen()),
            ),
            Divider(),
            _settingsRow(
              title: 'users',
              icon: Icons.people_alt_outlined,
              onTap: () => Get.to(() => UserListScreen()),
            ),
            Divider(),

            _settingsRow(
              title: 'language_change',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => LanguageBottomSheet(),
                );
              },
              icon: Icons.language_outlined,
            ),
            Divider(),
            _settingsRow(
              icon: Icons.logout_outlined,
              iconColor: AppColors.errorColor,
              title: 'logout',
              showArrow: false,
              onTap: () => Get.dialog(LogoutDialog()),
            ),
            Divider(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                Text(
                  'Customer ID: ${loginController.usertID}',
                  style: bodyStyle.copyWith(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InkWell _settingsRow({
    IconData? icon,
    Color? iconColor,
    String? image,
    required String title,
    Function()? onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: iconColor),
            if (image != null)
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            SizedBox(width: 10),
            Text(
              title.tr,
              style: bodyStyle.copyWith(color: iconColor ?? Colors.black),
            ),
            if (showArrow) Spacer(),
            if (showArrow) Icon(Icons.arrow_forward_ios_outlined),
          ],
        ),
      ),
    );
  }
}
