import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/controllers/login_controllers.dart';
import 'package:flutter_texmunimx/screens/settings_screen/widgets/language_bottom_sheet.dart';
import 'package:flutter_texmunimx/screens/settings_screen/widgets/logout_dialog.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:flutter_texmunimx/utils/app_images.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Divider(),
          _settingsRow(
            title: 'machine_group',
            image: AppImages.imgSettings,
            onTap: () {},
          ),
          Divider(),
          _settingsRow(
            title: 'machine_configure',
            image: AppImages.imgSettings1,
          ),
          Divider(),
          _settingsRow(
            title: 'maintenance_category',
            icon: Icons.list_alt_outlined,
          ),
          Divider(),
          _settingsRow(title: 'maintenance_entry', icon: Icons.add),
          Divider(),
          _settingsRow(title: 'shift_wise_comment_update', icon: Icons.list),
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
        ],
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
