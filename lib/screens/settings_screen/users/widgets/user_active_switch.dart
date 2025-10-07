import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackweaving/common_widgets/animated_alert_switch.dart';

class UserActiveSwitch extends StatelessWidget {
  final bool isActive;
  final Function(bool) onChanged;
  const UserActiveSwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            '${'is_active'.tr}:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        SizedBox(width: 12),

        SizedBox(
          height: 46,
          child: AnimatedAlertSwitch(
            current: isActive,
            onChanged: onChanged,
            onTitle: 'ON',
            offTitle: 'OFF',
          ),
        ),
      ],
    );
  }
}
