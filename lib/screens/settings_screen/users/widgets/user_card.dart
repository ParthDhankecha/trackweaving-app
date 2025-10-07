import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:trackweaving/common_widgets/animated_alert_switch.dart';
import 'package:trackweaving/models/users_list_response.dart';
import 'package:trackweaving/screens/settings_screen/users/widgets/user_active_switch.dart';
import 'package:trackweaving/utils/app_colors.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final Function()? onTap;
  final Function(bool) onActiveChanged;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        child: Container(
          decoration: BoxDecoration(
            color: user.isActive ? Colors.white : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                    width: 140,
                    child: AnimatedAlertSwitch(
                      current: user.isActive,
                      onChanged: onActiveChanged,
                      onTitle: 'Active',
                      offTitle: 'Inactive',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),

              buildRow(
                label: 'user_full_name'.tr,
                value: user.fullname,
                icon: Icons.badge_outlined,
              ),
              SizedBox(height: 4),
              buildRow(
                label: 'user_name'.tr,
                value: user.userName,
                icon: Icons.person_outlined,
              ),
              SizedBox(height: 4),
              buildRow(
                label: 'mobile'.tr,
                value: user.mobile,
                icon: Icons.phone_android_outlined,
              ),
              SizedBox(height: 4),

              buildRow(
                label: 'email'.tr,
                value: user.email,
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 4),
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
