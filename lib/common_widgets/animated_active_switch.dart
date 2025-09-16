import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:get/get.dart';

class AnimatedActiveSwitch extends StatelessWidget {
  final bool current;

  final Function(bool value) onChanged;
  const AnimatedActiveSwitch({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AnimatedToggleSwitch<bool>.dual(
        current: current,
        first: false,
        second: true,
        spacing: 2.0,
        style: const ToggleStyle(
          borderColor: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        borderWidth: 2.0,
        height: 30,
        onChanged: onChanged,
        styleBuilder: (b) => ToggleStyle(
          indicatorColor: !b ? Colors.grey : Colors.green,
          // backgroundColor: b ? Colors.green : Colors.orange,
        ),
        iconBuilder: (value) => value
            ? const Icon(
                Icons.power_settings_new,
                color: Colors.white,
                size: 20,
              )
            : const Icon(
                Icons.power_settings_new,
                color: Colors.white,
                size: 20,
              ),
        textBuilder: (value) => value
            ? Center(
                child: Text(
                  'active'.tr,
                  style: bodyStyle1.copyWith(color: Colors.green),
                ),
              )
            : Center(
                child: Text(
                  'inactive'.tr,
                  style: bodyStyle1.copyWith(color: Colors.grey),
                ),
              ),
      ),
    );
  }
}
